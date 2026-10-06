import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/contact_model.dart';
import '../models/payment_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TransactionModel>> getTransactions() {
    return _firestore.collection('transactions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TransactionModel(
          id: doc.id,
          contactId: data['contactId'] ?? '',
          amount: (data['amount'] ?? 0).toDouble(),
          type: TransactionType.values.firstWhere(
              (e) => e.toString() == data['type'],
              orElse: () => TransactionType.given),
          interestRate: (data['interestRate'] ?? 0).toDouble(),
          interestType: InterestType.values.firstWhere(
              (e) => e.toString() == data['interestType'],
              orElse: () => InterestType.monthly),
          startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
          notes: data['notes'],
          status: TransactionStatus.values.firstWhere(
              (e) => e.toString() == data['status'],
              orElse: () => TransactionStatus.active),
          paymentIds: List<String>.from(data['paymentIds'] ?? []),
        );
      }).toList();
    });
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestore.collection('transactions').doc(transaction.id).set({
      'contactId': transaction.contactId,
      'amount': transaction.amount,
      'type': transaction.type.toString(),
      'interestRate': transaction.interestRate,
      'interestType': transaction.interestType.toString(),
      'startDate': Timestamp.fromDate(transaction.startDate),
      'dueDate': transaction.dueDate != null ? Timestamp.fromDate(transaction.dueDate!) : null,
      'notes': transaction.notes,
      'status': transaction.status.toString(),
      'paymentIds': transaction.paymentIds,
    });
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await addTransaction(transaction); // set handles both create and update
  }

  Future<void> deleteTransaction(String id) async {
    await _firestore.collection('transactions').doc(id).delete();
  }

  Stream<List<PaymentModel>> getPayments(String transactionId) {
    return _firestore.collection('transactions').doc(transactionId).collection('payments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PaymentModel(
          id: doc.id,
          transactionId: transactionId,
          paymentDate: (data['paymentDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          amount: (data['amount'] ?? 0).toDouble(),
          mode: PaymentMode.values.firstWhere(
              (e) => e.toString() == data['mode'],
              orElse: () => PaymentMode.other),
          proofImagePath: data['proofImagePath'],
        );
      }).toList();
    });
  }

  Future<void> addPayment(PaymentModel payment) async {
    await _firestore.collection('transactions').doc(payment.transactionId).collection('payments').doc(payment.id).set({
      'paymentDate': Timestamp.fromDate(payment.paymentDate),
      'amount': payment.amount,
      'mode': payment.mode.toString(),
      'proofImagePath': payment.proofImagePath,
    });
  }
}
