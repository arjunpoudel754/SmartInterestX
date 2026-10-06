import 'package:hive/hive.dart';
import 'package:my_backend_app_2/models/contact_model.dart';
import 'package:my_backend_app_2/models/payment_model.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';


class HiveService {
  static const String contactBoxName = 'contacts';
  static const String transactionBoxName = 'transactions';
  static const String paymentBoxName = 'payments';

  Box<ContactModel> get _contactBox => Hive.box<ContactModel>(contactBoxName);
  Box<TransactionModel> get _transactionBox =>
      Hive.box<TransactionModel>(transactionBoxName);
  Box<PaymentModel> get _paymentBox => Hive.box<PaymentModel>(paymentBoxName);

  // ---------- Contacts ----------
  Future<void> addContact(ContactModel contact) => _contactBox.put(contact.id, contact);

  List<ContactModel> getAllContacts() => _contactBox.values.toList();

  ContactModel? getContact(String id) => _contactBox.get(id);

  Future<void> updateContact(ContactModel contact) => contact.save();

  Future<void> deleteContact(String id) => _contactBox.delete(id);

  // ---------- Transactions ----------
  Future<void> addTransaction(TransactionModel transaction) =>
      _transactionBox.put(transaction.id, transaction);

  List<TransactionModel> getAllTransactions() => _transactionBox.values.toList();

  List<TransactionModel> getTransactionsForContact(String contactId) =>
      _transactionBox.values.where((t) => t.contactId == contactId).toList();

  TransactionModel? getTransaction(String id) => _transactionBox.get(id);

  Future<void> updateTransaction(TransactionModel transaction) => transaction.save();

  Future<void> deleteTransaction(String id) => _transactionBox.delete(id);

  // ---------- Payments ----------
  Future<void> addPayment(PaymentModel payment) => _paymentBox.put(payment.id, payment);

  List<PaymentModel> getPaymentsForTransaction(String transactionId) =>
      _paymentBox.values.where((p) => p.transactionId == transactionId).toList();

  Future<void> deletePayment(String id) => _paymentBox.delete(id);
}