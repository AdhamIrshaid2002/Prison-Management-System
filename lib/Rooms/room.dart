
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:police/Prisoner/prisoner.dart';

import 'addroom.dart';
import 'editroom.dart';

class Rooms extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const Rooms({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  List<QueryDocumentSnapshot> rooms = [];

  getRooms() async {
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("rooms")
        .get();

    rooms = q.docs;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Department Rooms: ${widget.categoryName}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRoom(
                categoryId: widget.categoryId,
              ),
            ),
          ).then((_) => getRooms());
        },
      ),

      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, i) {
          var room = rooms[i];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            elevation: 3,
            child: ListTile(
              title: Text(
                room["name"],
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                "Capacity: ${room["capacity"]}",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Prisoners(
                      categoryId: widget.categoryId,
                      roomId: room.id,
                      roomName: room["name"],
                    ),
                  ),
                ).then((_) => getRooms());
              },

              onLongPress: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: "Warning",
                  desc: "Choose what you want.",
                  btnCancelText: "Delete",
                  btnCancelOnPress: () async {
                    await FirebaseFirestore.instance
                        .collection("categories")
                        .doc(widget.categoryId)
                        .collection("rooms")
                        .doc(room.id)
                        .delete();

                    getRooms();
                  },
                  btnOkText: "Edit",
                  btnOkOnPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRoom(
                          categoryId: widget.categoryId,
                          roomId: room.id,
                          roomName: room["name"],
                          capacity: room["capacity"],
                        ),
                      ),
                    ).then((_) => getRooms());
                  },
                ).show();
              },
            ),
          );
        },
      ),
    );
  }
}

