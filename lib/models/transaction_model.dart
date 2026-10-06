import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 3)
enum TransactionType {
  @HiveField(0)
  given, // you lent money

  @HiveField(1)
  taken, // you borrowed money
}

@HiveType(typeId: 4)
enum InterestType {
  @HiveField(0)
  monthly,

  @HiveField(1)
  yearly,
}

@HiveType(typeId: 5)
enum TransactionStatus {
  @HiveField(0)
  active,

  @HiveField(1)
  partiallyPaid,

  @HiveField(2)
  settled,
}

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String contactId;

  @HiveField(2)
  double amount;

  @HiveField(3)
  TransactionType type;

  @HiveField(4)
  double interestRate;

  @HiveField(5)
  InterestType interestType;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime? dueDate;

  @HiveField(8)
  String? notes;

  @HiveField(9)
  TransactionStatus status;

  @HiveField(10)
  List<String> paymentIds;

  TransactionModel({
    required this.id,
    required this.contactId,
    required this.amount,
    required this.type,
    required this.interestRate,
    required this.interestType,
    required this.startDate,
    this.dueDate,
    this.notes,
    this.status = TransactionStatus.active,
    List<String>? paymentIds,
  }) : paymentIds = paymentIds ?? [];
} 