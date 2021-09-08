import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/src/screens/home/home_page.dart';
import 'package:flutter_firebase/src/screens/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print('Error');
            return Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            print('Success');
            // return HomePage();
            return LoginPage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading'),
            ),
          );
        },
      ),
    );
  }
}
