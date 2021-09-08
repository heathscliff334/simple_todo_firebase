import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoHistory extends StatefulWidget {
  const TodoHistory({Key? key}) : super(key: key);

  @override
  _TodoHistoryState createState() => _TodoHistoryState();
}

class _TodoHistoryState extends State<TodoHistory> {
  String? _userUid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // ? Untuk delete / remove data di colleciton harus tambahkan dulu tipe data CollectionReference
  CollectionReference todo_lists =
      FirebaseFirestore.instance.collection('todo_lists');
  // ? Stream tipe datanya 'QuerySnapshot' = data yang didalamnya ada data
  Stream<QuerySnapshot<Map<String, dynamic>>> collectionStream =
      FirebaseFirestore.instance
          .collection('todo_lists')
          .orderBy('todo', descending: false)
          .snapshots(); //snapshot = minta notify
  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userUid = prefs.getString('id');
      prefs.commit();
    });
    // print('pref saved');
    print('get the prefs');
    print(_userUid);
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Widget build(BuildContext context) {
    // if (collectionStream.length != 0) {
    //   print('null collection stream!');
    // }
    return Scaffold(
      // ? Untuk mengambil data dari stream harus menggunakan streambuilder
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                          // ! Ada banyak pilihan
                          // ? set() = update data
                          // * get() = get data
                          // ! delete() = delete data
                          // todo_lists.doc(snapshot.data!.docs[i].id).delete();
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
    );
  }
}
