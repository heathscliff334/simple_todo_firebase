import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool? _success;
  String? _userEmail;

  _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      _success = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _success = false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        _success = false;
      }
    } catch (e) {
      print(e);
      print("ERROR WOI!");
      _success = false;
    }
  }

  popUpAlert() {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(content: SizedBox(child: Text('TEST')));
      },
    );
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
                          delegate: SliverChildListDelegate(
                            [
                              Container(height: 100),
                              Container(
                                // height: 40,
                                // color: Colors.red,
                                child: TextFormField(
                                  controller: _emailController,
                                  // keyboardType: TextInputType.text,
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
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
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
                                  keyboardType: TextInputType.visiblePassword,
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
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
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
                                  onPressed: () async {
                                    _register();
                                  },
                                  child: Text('Register'),
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
                                  color: Colors.white,
                                  onPressed: () {},
                                  child: Text('Register with Google'),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: MaterialButton(
                                  color: Colors.white,
                                  onPressed: () {},
                                  child: Text('Register with Facebook'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverFillRemaining(
                            child: Container(
                          padding: EdgeInsets.all(10),
                          height: 15,
                          // color: Colors.red,
                          alignment: Alignment.bottomCenter,
                          child: (_success == true)
                              ? Container(
                                  // alignment: Alignment.bottomCenter,
                                  height: 30,
                                  width: double.infinity,
                                  color: Colors.blue[200],
                                  child: Center(
                                    child: Text(
                                      'Registeration success !',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                              : Container(
                                  // alignment: Alignment.bottomCenter,
                                  height: 30,
                                  width: double.infinity,
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      'Registeration failed !',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                        )),
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
