
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRoom extends StatefulWidget {
  final String categoryId;

  const AddRoom({
    super.key,
    required this.categoryId,
  });

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController capacity = TextEditingController();

  addRoom() async {
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .collection("rooms")
          .add({
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
          "Add Room",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              Container(height: 20),

              TextFormField(
                controller: capacity,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Enter room capacity" : null,
                decoration: InputDecoration(
                  labelText: "Room Capacity",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: addRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

