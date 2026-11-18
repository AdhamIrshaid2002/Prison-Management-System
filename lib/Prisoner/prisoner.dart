
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:police/Prisoner/Details.dart';
import 'package:police/Prisoner/MovePrisoner.dart';
import 'editprisoner.dart';
import 'addprisoner.dart';

class Prisoners extends StatefulWidget {
  final String categoryId;
  final String roomId;
  final String roomName;

  const Prisoners({
    super.key,
    required this.categoryId,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<Prisoners> createState() => _PrisonersState();
}

class _PrisonersState extends State<Prisoners> {
  List<QueryDocumentSnapshot> prisoners = [];

  getPrisoners() async {
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("rooms")
        .doc(widget.roomId)
        .collection("prisoners")
        .get();

    List<QueryDocumentSnapshot> temp = [];
    DateTime now = DateTime.now();

    for (var doc in q.docs) {
      DateTime? releaseDate = (doc["releaseDate"] as Timestamp?)?.toDate();

      if (releaseDate != null && releaseDate.isBefore(now)) {
        await FirebaseFirestore.instance
            .collection("categories")
            .doc(widget.categoryId)
            .collection("rooms")
            .doc(widget.roomId)
            .collection("prisoners")
            .doc(doc.id)
            .delete();
      } else {
        temp.add(doc);
      }
    }

    prisoners = temp;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPrisoners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.roomName} - Room Prisoners",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person_add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPrisoner(
                categoryId: widget.categoryId,
                roomId: widget.roomId,
              ),
            ),
          ).then((_) => getPrisoners());
        },
      ),
      body: prisoners.isEmpty
          ? Center(
              child: Text(
                "No prisoners",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: prisoners.length,
              itemBuilder: (context, i) {
                var p = prisoners[i];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      p["name"],
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Crime: ${p["crime"]} | Sentence Duration: ${p["sentenceYears"]} Years",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrisonerDetails(
                            name: p["name"],
                            crime: p["crime"],
                            sentenceYears: p["sentenceYears"],
                            entryDate:
                                (p["entryDate"] as Timestamp?)?.toDate(),
                            releaseDate:
                                (p["releaseDate"] as Timestamp?)?.toDate(),
                            visitDay: p["visitDay"],
                            visitTime: p["visitTime"],
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Prisoner Options"),
                          content: Text(
                            "Choose the operation you want to perform",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("categories")
                                    .doc(widget.categoryId)
                                    .collection("rooms")
                                    .doc(widget.roomId)
                                    .collection("prisoners")
                                    .doc(p.id)
                                    .delete();

                                Navigator.pop(context);
                                getPrisoners();
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPrisoner(
                                      categoryId: widget.categoryId,
                                      roomId: widget.roomId,
                                      prisonerId: p.id,
                                      name: p["name"],
                                      crime: p["crime"],
                                      sentenceYears: p["sentenceYears"],
                                      entryDate:
                                          (p["entryDate"] as Timestamp?)
                                              ?.toDate(),
                                      releaseDate:
                                          (p["releaseDate"] as Timestamp?)
                                              ?.toDate(),
                                      visitDay: p["visitDay"],
                                      visitTime: p["visitTime"],
                                    ),
                                  ),
                                ).then((_) => getPrisoners());
                              },
                              child: Text("Edit"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovePrisonerPage(
                                      prisonerDoc: p,
                                      currentCategoryId:
                                          widget.categoryId,
                                      currentRoomId: widget.roomId,
                                    ),
                                  ),
                                ).then((_) => getPrisoners());
                              },
                              child: Text(
                                "Move",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
