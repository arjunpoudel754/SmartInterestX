import 'package:hive/hive.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 6)
enum PaymentMode {
  @HiveField(0)
  upi,

  @HiveField(1)
  bankTransfer,

  @HiveField(2)
  cash,

  @HiveField(3)
  other,
}

@HiveType(typeId: 2)
class PaymentModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String transactionId;

  @HiveField(2)
  DateTime paymentDate;

  @HiveField(3)
  double amount;

  @HiveField(4)
  PaymentMode mode;

  @HiveField(5)
  String? proofImagePath;

  PaymentModel({
    required this.id,
    required this.transactionId,
    required this.paymentDate,
    required this.amount,
    required this.mode,
    this.proofImagePath,
  });
}