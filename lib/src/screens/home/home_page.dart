import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/src/screens/home/add_page.dart';
import 'package:flutter_firebase/src/screens/home/todo_history/todo_history.dart';
import 'package:flutter_firebase/src/screens/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userUid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // ? Untuk delete / remove data di colleciton harus tambahkan dulu tipe data CollectionReference
  // ? To do a get(), set(), and delete() we must add CollectionReference data
  CollectionReference todo_lists =
      FirebaseFirestore.instance.collection('todo_lists');
  // ? Stream tipe datanya 'QuerySnapshot' = data yang didalamnya ada data
  // ? The type of Stream variable is 'QuerySnapshot' = there is a data inside data
  Stream<QuerySnapshot<Map<dynamic, dynamic>>> collectionStream =
      FirebaseFirestore.instance
          .collection('todo_lists')
          .orderBy('todo', descending: false)
          // .where('user', isEqualTo: _userUid.)
          .snapshots();

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        _auth.signOut();
        print('Logout successfull');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()));

        break;
      case 'Settings':
        break;
      case 'History':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoHistory()));
        break;
    }
  }

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
    // if (collectionStream.length != 0) {
    //   print('null collection stream!');
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'History', 'Settings', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      // ? Untuk mengambil data dari stream harus menggunakan streambuilder
      body: StreamBuilder<QuerySnapshot<Map<dynamic, dynamic>>>(
        stream: collectionStream,
        builder: (context, snapshot) {
          // snapshot.data!.docs.map((e) => print(e.data()));

          return Container(
            // height: double.infinity / 2,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: ListTile(
                      // title: Text(snapshot.data!.docs[i].data().toString()), // outputnya (name:kevin)
                      title: Text(
                        snapshot.data!.docs[i].data()['todo'],
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.check_box_outline_blank_sharp),
                        onPressed: () {
                          // ? set() = update data
                          // * get() = get data
                          // ! delete() = delete data
                          // todo_lists.doc(snapshot.data!.docs[i].id).delete();

                          todo_lists.doc(snapshot.data!.docs[i].id).set({
                            'check': '1',
                            'todo': snapshot.data!.docs[i].data()['todo'],
                            'user': snapshot.data!.docs[i].data()['user'],
                          });
                        },
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(10)),
                  );
                }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // users.doc('name')
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
