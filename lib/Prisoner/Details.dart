
import 'package:flutter/material.dart';

class PrisonerDetails extends StatelessWidget {
  final String name;
  final String crime;
  final int sentenceYears;
  final DateTime? entryDate;
  final DateTime? releaseDate;
  final String? visitDay;
  final String? visitTime;

  const PrisonerDetails({
    super.key,
    required this.name,
    required this.crime,
    required this.sentenceYears,
    this.entryDate,
    this.releaseDate,
    this.visitDay,
    this.visitTime,
  });

  String formatDate(DateTime? date) {
    if (date == null) return "Not Specified";
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget infoRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),

          SizedBox(width: 12),

          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prisoner Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          shadowColor: Colors.blue.shade200,

          child: Padding(
            padding: EdgeInsets.all(20),

            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  name,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),

                Divider(
                  height: 30,
                  thickness: 2,
                ),

                infoRow(
                  Icons.gavel,
                  "Crime",
                  crime,
                  Colors.orange.shade700,
                ),

                infoRow(
                  Icons.timer,
                  "Sentence Duration",
                  "$sentenceYears Years",
                  Colors.red.shade700,
                ),

                infoRow(
                  Icons.calendar_today,
                  "Arrest Date",
                  formatDate(entryDate),
                  Colors.green.shade700,
                ),

                infoRow(
                  Icons.calendar_view_day,
                  "Release Date",
                  formatDate(releaseDate),
                  Colors.purple.shade700,
                ),

                infoRow(
                  Icons.event,
                  "Visit Day",
                  visitDay ?? "Not Specified",
                  Colors.teal.shade700,
                ),

                infoRow(
                  Icons.access_time,
                  "Visit Time",
                  visitTime ?? "Not Specified",
                  Colors.brown.shade700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

