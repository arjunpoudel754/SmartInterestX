import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_backend_app_2/app.dart';
import 'package:my_backend_app_2/models/contact_model.dart';
import 'package:my_backend_app_2/models/payment_model.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';
import 'package:my_backend_app_2/providers/contact_provider.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:my_backend_app_2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required before any async setup pre-runApp

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  // Models
  Hive.registerAdapter(ContactModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(PaymentModelAdapter());

  // Enums used inside TransactionModel / PaymentModel
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(InterestTypeAdapter());
  Hive.registerAdapter(TransactionStatusAdapter());
  Hive.registerAdapter(PaymentModeAdapter());

  // Open boxes here (or inside hive_service.dart, called from here)
  await Hive.openBox<ContactModel>('contacts');
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<PaymentModel>('payments');

     runApp(
     MultiProvider(
       providers: [
         ChangeNotifierProvider(create: (_) => ContactProvider()..loadContacts()),
         ChangeNotifierProvider(create: (_) => TransactionProvider()..loadTransactions()),
       ],
       child: MyApp(),
     ),
   );
}

