
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  final String docid;
  final String oname;

  const Edit({
    super.key,
    required this.docid,
    required this.oname,
  });

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection(
    "categories",
  );

  editCategory() async {
    if (formState.currentState!.validate()) {
      try {
        await categories.doc(widget.docid).update({
          "name": name.text,
        });

        Navigator.of(context).pushReplacementNamed("home");
      } catch (e) {
        print("Error $e ");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Edit Department",
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
              child: Text("Save"),
              color: Color.fromARGB(255, 5, 102, 181),
              textColor: Colors.white,
              onPressed: () {
                editCategory();
              },
            ),
          ],
        ),
      ),
    );
  }
}
