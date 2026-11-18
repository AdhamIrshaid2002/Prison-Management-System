
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:police/Prisoner/prisoner.dart';
import 'package:police/Rooms/room.dart';
import 'package:police/botton.dart';
import 'package:police/deparment/edit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where(
          "id",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Prison Departments",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'app');
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'adddep');
        },
      ),

      body: Container(
        padding: EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 160,
          ),
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton(
                onLongPress: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Warning!',
                    desc: 'Choose what you want.',
                    btnCancelText: 'Delete',
                    btnCancelOnPress: () async {
                      await FirebaseFirestore.instance
                          .collection("categories")
                          .doc(data[i].id)
                          .delete();

                      Navigator.of(context).pushReplacementNamed("home");
                    },
                    btnOkText: 'Edit',
                    btnOkOnPress: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Edit(
                            docid: data[i].id,
                            oname: "${data[i]["name"]}",
                          ),
                        ),
                      );
                    },
                  ).show();
                },

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Rooms(
                        categoryId: data[i].id,
                        categoryName: data[i]["name"],
                      ),
                    ),
                  );
                },

                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: Size(200, 80),
                ),

                child: Center(
                  child: Text(
                    "${data[i]["name"]}",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: BottomNav(
        onHomePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        },

        onVisitsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Prisoners(
                categoryId: "Put the appropriate categoryId here",
                roomId: "Put the appropriate roomId here",
                roomName: "Room 1",
              ),
            ),
          );
        },
      ),
    );
  }
}

