
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPrisoner extends StatefulWidget {
  final String categoryId;
  final String roomId;
  final String prisonerId;
  final String name;
  final String crime;
  final int sentenceYears;
  final DateTime? entryDate;
  final DateTime? releaseDate;
  final String? visitDay;
  final String? visitTime;

  const EditPrisoner({
    super.key,
    required this.categoryId,
    required this.roomId,
    required this.prisonerId,
    required this.name,
    required this.crime,
    required this.sentenceYears,
    this.entryDate,
    this.releaseDate,
    this.visitDay,
    this.visitTime,
  });

  @override
  State<EditPrisoner> createState() => _EditPrisonerState();
}

class _EditPrisonerState extends State<EditPrisoner> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController crimeController;
  late TextEditingController yearsController;

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

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    crimeController = TextEditingController(text: widget.crime);
    yearsController = TextEditingController(
      text: widget.sentenceYears.toString(),
    );

    entryDate = widget.entryDate;
    releaseDate = widget.releaseDate;
    visitDay = widget.visitDay;

    if (widget.visitTime != null) {
      final parts = widget.visitTime!.split(":");

      visitTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
  }

  void editPrisoner() async {
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
        .doc(widget.prisonerId)
        .update({
      "name": nameController.text,
      "crime": crimeController.text,
      "sentenceYears": int.parse(yearsController.text),
      "entryDate": entryDate,
      "releaseDate": releaseDate,
      "visitDay": visitDay,
      "visitTime": "${visitTime!.hour}:${visitTime!.minute}",
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Prisoner"),
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
                    initialDate: entryDate ?? DateTime.now(),
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
                    initialDate: releaseDate ?? DateTime.now(),
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
                    initialTime:
                        visitTime ?? TimeOfDay.now(),
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
                onPressed: editPrisoner,
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

