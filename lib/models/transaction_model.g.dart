// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      contactId: fields[1] as String,
      amount: fields[2] as double,
      type: fields[3] as TransactionType,
      interestRate: fields[4] as double,
      interestType: fields[5] as InterestType,
      startDate: fields[6] as DateTime,
      dueDate: fields[7] as DateTime?,
      notes: fields[8] as String?,
      status: fields[9] as TransactionStatus,
      paymentIds: (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contactId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.interestRate)
      ..writeByte(5)
      ..write(obj.interestType)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.dueDate)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.paymentIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 3;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.given;
      case 1:
        return TransactionType.taken;
      default:
        return TransactionType.given;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.given:
        writer.writeByte(0);
        break;
      case TransactionType.taken:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InterestTypeAdapter extends TypeAdapter<InterestType> {
  @override
  final int typeId = 4;

  @override
  InterestType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InterestType.monthly;
      case 1:
        return InterestType.yearly;
      default:
        return InterestType.monthly;
    }
  }

  @override
  void write(BinaryWriter writer, InterestType obj) {
    switch (obj) {
      case InterestType.monthly:
        writer.writeByte(0);
        break;
      case InterestType.yearly:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterestTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionStatusAdapter extends TypeAdapter<TransactionStatus> {
  @override
  final int typeId = 5;

  @override
  TransactionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionStatus.active;
      case 1:
        return TransactionStatus.partiallyPaid;
      case 2:
        return TransactionStatus.settled;
      default:
        return TransactionStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionStatus obj) {
    switch (obj) {
      case TransactionStatus.active:
        writer.writeByte(0);
        break;
      case TransactionStatus.partiallyPaid:
        writer.writeByte(1);
        break;
      case TransactionStatus.settled:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
