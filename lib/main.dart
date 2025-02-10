import 'package:contact_app/screens/auth_screen.dart';
import 'package:contact_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  options: const FirebaseOptions(
      apiKey: 'AIzaSyBHHrdkuiWQB5ul04u--oVlRYoPbxYSTuw',
      appId: '1:797074755402:android:be50270d395e0a875cbbb3',
      messagingSenderId: '756823544685',
      projectId: 'food-delivery-b7d4d')); // Initialize Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Food App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
      },
    );
  }
}