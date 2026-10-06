// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentModelAdapter extends TypeAdapter<PaymentModel> {
  @override
  final int typeId = 2;

  @override
  PaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentModel(
      id: fields[0] as String,
      transactionId: fields[1] as String,
      paymentDate: fields[2] as DateTime,
      amount: fields[3] as double,
      mode: fields[4] as PaymentMode,
      proofImagePath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.transactionId)
      ..writeByte(2)
      ..write(obj.paymentDate)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.mode)
      ..writeByte(5)
      ..write(obj.proofImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentModeAdapter extends TypeAdapter<PaymentMode> {
  @override
  final int typeId = 6;

  @override
  PaymentMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentMode.upi;
      case 1:
        return PaymentMode.bankTransfer;
      case 2:
        return PaymentMode.cash;
      case 3:
        return PaymentMode.other;
      default:
        return PaymentMode.upi;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentMode obj) {
    switch (obj) {
      case PaymentMode.upi:
        writer.writeByte(0);
        break;
      case PaymentMode.bankTransfer:
        writer.writeByte(1);
        break;
      case PaymentMode.cash:
        writer.writeByte(2);
        break;
      case PaymentMode.other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
