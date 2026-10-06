// transaction_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../models/payment_model.dart';
import '../services/firebase_service.dart';

class TransactionProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final _uuid = const Uuid();

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;
  StreamSubscription? _subscription;

  void loadTransactions() {
    _subscription?.cancel();
    _subscription = _firebaseService.getTransactions().listen((data) {
      _transactions = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> addTransaction({
    required String contactId,
    required double amount,
    required TransactionType type,
    required double interestRate,
    required InterestType interestType,
    required DateTime startDate,
    DateTime? dueDate,
    String? notes,
  }) async {
    final transaction = TransactionModel(
      id: _uuid.v4(),
      contactId: contactId,
      amount: amount,
      type: type,
      interestRate: interestRate,
      interestType: interestType,
      startDate: startDate,
      dueDate: dueDate,
      notes: notes,
    );
    await _firebaseService.addTransaction(transaction);
  }

  // Stream payments for a given transaction
  Stream<List<PaymentModel>> getPaymentsForTransaction(String transactionId) {
    return _firebaseService.getPayments(transactionId);
  }



  Future<void> recordPayment({
    required String transactionId,
    required double amount,
    required PaymentMode mode,
    String? proofImagePath,
  }) async {
    // Create payment entry
    final payment = PaymentModel(
      id: _uuid.v4(),
      transactionId: transactionId,
      paymentDate: DateTime.now(),
      amount: amount,
      mode: mode,
      proofImagePath: proofImagePath,
    );
    await _firebaseService.addPayment(payment);

    // Update transaction status if needed (e.g., partiallyPaid or settled)
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      final transaction = _transactions[index];
      // Recalculate total paid amount
      final payments = await _firebaseService.getPayments(transactionId).first;
      final paidSum = payments.fold<double>(0, (sum, p) => sum + p.amount);
      final totalAmount = transaction.amount +
          ((transaction.interestType == InterestType.monthly
                  ? (DateTime.now().year - transaction.startDate.year) * 12 +
                      (DateTime.now().month - transaction.startDate.month)
                  : (DateTime.now().year - transaction.startDate.year)) *
              transaction.interestRate * transaction.amount) /
          100;
      if (paidSum >= totalAmount) {
        transaction.status = TransactionStatus.settled;
      } else {
        transaction.status = TransactionStatus.partiallyPaid;
      }
      await _firebaseService.updateTransaction(transaction);
    }
  }

  /// Deletes a transaction both remotely and locally.
  Future<void> deleteTransaction(String transactionId) async {
    // Remove from Firestore
    await _firebaseService.deleteTransaction(transactionId);
    // Remove from local list if present
    _transactions.removeWhere((t) => t.id == transactionId);
    notifyListeners();
  }

}

