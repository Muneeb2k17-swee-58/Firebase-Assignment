import 'package:flutter/material.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  get data => null;
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Container();
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            // ignore: prefer_const_constructors
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                routes: {
                  '/login': (context) => Login(),
                  '/register': (context) => Register(),
                  '/home': (context) => Home(),
                },
                // ignore: prefer_const_constructors
                home: Scaffold(body: Login()));
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Container();
        });
  }
}
