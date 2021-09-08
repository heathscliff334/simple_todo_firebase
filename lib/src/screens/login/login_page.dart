import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/src/screens/home/home_page.dart';
import 'package:flutter_firebase/src/screens/home/register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? tempUid;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController =
      TextEditingController(text: 'yukizoe332@gmail.com');
  TextEditingController _passwordController =
      TextEditingController(text: 'lauren');

  void signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      print('Login success');
      print(userCredential.user!.uid.characters);

      tempUid = userCredential.user!.uid.characters.toString();
      print('Temp UID : $tempUid');
      savePref(tempUid!);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  savePref(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('id', id);
      prefs.commit();
    });
    // print('pref saved');
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tempUid = prefs.getString('id');
      prefs.commit();
    });
    // print('pref saved');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              // Background
              Container(
                color: Colors.grey[100],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Container(height: 100),
                            Container(
                              // height: 40,
                              // color: Colors.red,
                              child: TextFormField(
                                controller: _emailController,
                                // keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              // height: 40,
                              // color: Colors.red,
                              child: TextFormField(
                                controller: _passwordController,
                                // keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              child: MaterialButton(
                                color: Colors.blue[200],
                                onPressed: () {
                                  signInWithEmailAndPassword();
                                },
                                child: Text('Login'),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                        thickness: 1, color: Colors.grey)),
                                Text('OR'),
                                Expanded(
                                    child: Divider(
                                        thickness: 1, color: Colors.grey))
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              child: MaterialButton(
                                color: Colors.blue[200],
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                                },
                                child: Text('Register'),
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
