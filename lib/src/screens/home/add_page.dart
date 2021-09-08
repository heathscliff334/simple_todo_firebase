import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _key = new GlobalKey<FormState>();
  String? _userUid;
  TextEditingController _nameController = TextEditingController();
  CollectionReference _todo =
      FirebaseFirestore.instance.collection('todo_lists');

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userUid = prefs.getString('id');
      prefs.commit();
    });
    // print('pref saved');
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          // color: Colors.red,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Todo'),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Input todo',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () {
                      _todo.add({
                        'check': '0',
                        'todo': '${_nameController.text}',
                        'user': _userUid,
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
