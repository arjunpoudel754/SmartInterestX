import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 0)
class ContactModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String mobile;

  @HiveField(3)
  String? email;

  ContactModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
  });
}