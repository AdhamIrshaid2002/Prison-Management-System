
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPrisoner extends StatefulWidget {
  final String categoryId;
  final String roomId;

  const AddPrisoner({
    super.key,
    required this.categoryId,
    required this.roomId,
  });

  @override
  State<AddPrisoner> createState() => _AddPrisonerState();
}

class _AddPrisonerState extends State<AddPrisoner> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final crimeController = TextEditingController();
  final yearsController = TextEditingController();

  DateTime? entryDate;
  DateTime? releaseDate;
  String? visitDay;
  TimeOfDay? visitTime;

  final List<String> daysOfWeek = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  void addPrisoner() async {
    if (!_formKey.currentState!.validate() ||
        entryDate == null ||
        releaseDate == null ||
        visitDay == null ||
        visitTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("rooms")
        .doc(widget.roomId)
        .collection("prisoners")
        .add({
      "name": nameController.text,
      "crime": crimeController.text,
      "sentenceYears": int.parse(yearsController.text),
      "entryDate": entryDate,
      "releaseDate": releaseDate,
      "visitDay": visitDay,
      "visitTime": "${visitTime!.hour}:${visitTime!.minute}",
      "createdAt": DateTime.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Prisoner"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Prisoner Name",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Enter prisoner name" : null,
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: crimeController,
                decoration: InputDecoration(
                  labelText: "Crime",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Enter crime" : null,
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: yearsController,
                decoration: InputDecoration(
                  labelText: "Sentence Duration (Years)",
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Enter sentence duration" : null,
              ),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() => entryDate = picked);
                  }
                },
                child: Text(
                  entryDate == null
                      ? "Select Arrest Date"
                      : "Arrest Date: ${entryDate!.toLocal()}"
                          .split(' ')[0],
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() => releaseDate = picked);
                  }
                },
                child: Text(
                  releaseDate == null
                      ? "Select Release Date"
                      : "Release Date: ${releaseDate!.toLocal()}"
                          .split(' ')[0],
                ),
              ),

              DropdownButton<String>(
                value: visitDay,
                hint: Text("Select Visit Day"),
                items: daysOfWeek
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(d),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => visitDay = v),
              ),

              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (picked != null) {
                    setState(() => visitTime = picked);
                  }
                },
                child: Text(
                  visitTime == null
                      ? "Select Visit Time"
                      : "Visit Time: ${visitTime!.format(context)}",
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: addPrisoner,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

