
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Adddept extends StatefulWidget {
  const Adddept({super.key});

  @override
  State<Adddept> createState() => _AdddeptState();
}

class _AdddeptState extends State<Adddept> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection(
    "categories",
  );

  addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        DocumentReference response = await categories.add({
          "name": name.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        });

        Navigator.of(context).pushReplacementNamed("home");
      } catch (e) {
        print("Error $e ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Add Department",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 25,
              ),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "The field is empty";
                  }
                },
                controller: name,
                decoration: InputDecoration(
                  hintText: "Add a new department",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            MaterialButton(
              child: Text("Add New Department"),
              color: Color.fromARGB(255, 5, 102, 181),
              textColor: Colors.white,
              onPressed: () {
                addCategory();
              },
            ),
          ],
        ),
      ),
    );
  }
}
