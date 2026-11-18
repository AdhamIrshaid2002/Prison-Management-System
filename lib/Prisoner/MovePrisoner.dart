
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MovePrisonerPage extends StatefulWidget {
  final QueryDocumentSnapshot prisonerDoc;
  final String currentCategoryId;
  final String currentRoomId;

  const MovePrisonerPage({
    super.key,
    required this.prisonerDoc,
    required this.currentCategoryId,
    required this.currentRoomId,
  });

  @override
  State<MovePrisonerPage> createState() => _MovePrisonerPageState();
}

class _MovePrisonerPageState extends State<MovePrisonerPage> {
  String? newCategoryId;
  String? newRoomId;

  List<QueryDocumentSnapshot> categories = [];
  List<QueryDocumentSnapshot> rooms = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  fetchCategories() async {
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection("categories")
        .get();

    categories = q.docs;
    setState(() {});
  }

  fetchRooms(String categoryId) async {
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection("categories")
        .doc(categoryId)
        .collection("rooms")
        .get();

    rooms = q.docs;
    setState(() {});
  }

  movePrisoner() async {
    if (newCategoryId == null || newRoomId == null) return;

    await FirebaseFirestore.instance
        .collection("categories")
        .doc(newCategoryId)
        .collection("rooms")
        .doc(newRoomId)
        .collection("prisoners")
        .doc(widget.prisonerDoc.id)
        .set(
          widget.prisonerDoc.data() as Map<String, dynamic>,
        );

    await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.currentCategoryId)
        .collection("rooms")
        .doc(widget.currentRoomId)
        .collection("prisoners")
        .doc(widget.prisonerDoc.id)
        .delete();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Move Prisoner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Center(
          child: Column(
            children: [
              DropdownButton<String>(
                hint: Text("Select Department"),
                value: newCategoryId,

                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c["name"]),
                      ),
                    )
                    .toList(),

                onChanged: (val) {
                  setState(() {
                    newCategoryId = val;
                    newRoomId = null;
                    rooms = [];
                  });

                  if (val != null) {
                    fetchRooms(val);
                  }
                },
              ),

              DropdownButton<String>(
                hint: Text("Select Room"),
                value: newRoomId,

                items: rooms
                    .map(
                      (r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r["name"]),
                      ),
                    )
                    .toList(),

                onChanged: (val) {
                  setState(() => newRoomId = val);
                },
              ),

              SizedBox(height: 20),

              MaterialButton(
                child: Text("Move"),
                color: Color.fromARGB(255, 5, 102, 181),
                textColor: Colors.white,
                onPressed: movePrisoner,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
