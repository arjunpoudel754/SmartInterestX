// contact_provider.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';
import '../services/hive_service.dart';

class ContactProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  final _uuid = const Uuid();

  List<ContactModel> _contacts = [];
  List<ContactModel> get contacts => _contacts;

  void loadContacts() {
    _contacts = _hiveService.getAllContacts();
    notifyListeners();
  }

  Future<void> addContact({
    required String name,
    required String mobile,
    String? email,
  }) async {
    final contact = ContactModel(
      id: _uuid.v4(),
      name: name,
      mobile: mobile,
      email: email,
    );
    await _hiveService.addContact(contact);
    loadContacts();
  }

  Future<void> updateContact(ContactModel contact) async {
    await _hiveService.updateContact(contact);
    loadContacts();
  }

  Future<void> deleteContact(String id) async {
    await _hiveService.deleteContact(id);
    loadContacts();
  }

  List<ContactModel> search(String query) {
    if (query.isEmpty) return _contacts;
    final lower = query.toLowerCase();
    return _contacts
        .where((c) =>
            c.name.toLowerCase().contains(lower) || c.mobile.contains(lower))
        .toList();
  }
}