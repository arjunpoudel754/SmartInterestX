// contact_list_screen.dart
import 'package:flutter/material.dart';
import 'package:my_backend_app_2/providers/contact_provider.dart';
import 'package:my_backend_app_2/screens/payment/payment_screen.dart';
import 'package:provider/provider.dart';
import 'add_contact_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<ContactProvider>().contacts;

    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: contacts.isEmpty
          ? const Center(child: Text('No contacts yet. Add one to get started.'))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
                  title: Text(contact.name),
                  subtitle: Text(contact.mobile),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context
                        .read<ContactProvider>()
                        .deleteContact(contact.id),
                  ),
                  onTap: () {
                    // TODO: navigate to a contact detail / transaction history screen
                    Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        contactId: contact.id, 
                        contactName: contact.name,
                      ),
                    ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddContactScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}