
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditRoom extends StatefulWidget {
  final String categoryId;
  final String roomId;
  final String roomName;
  final int capacity;

  const EditRoom({
    super.key,
    required this.categoryId,
    required this.roomId,
    required this.roomName,
    required this.capacity,
  });

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController capacity;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.roomName);
    capacity = TextEditingController(text: widget.capacity.toString());
  }

  editRoom() async {
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .collection("rooms")
          .doc(widget.roomId)
          .update({
        "name": name.text,
        "capacity": int.parse(capacity.text),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Room",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                validator: (v) =>
                    v!.isEmpty ? "Enter room name" : null,
                decoration: InputDecoration(
                  labelText: "Room Name",
                ),
              ),

              TextFormField(
                controller: capacity,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Enter capacity" : null,
                decoration: InputDecoration(
                  labelText: "Room Capacity",
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: editRoom,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

