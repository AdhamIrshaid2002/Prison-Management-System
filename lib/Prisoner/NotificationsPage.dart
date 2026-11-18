
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .orderBy("scheduledAt", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No notifications"));
          }

          final seen = <String>{};

          final uniqueDocs = docs.where((d) {
            if (seen.contains(d.id)) return false;
            seen.add(d.id);
            return true;
          }).toList();

          return ListView.builder(
            itemCount: uniqueDocs.length,
            itemBuilder: (context, i) {
              final n = uniqueDocs[i];
              final ts = n['scheduledAt'] as Timestamp;

              return ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(n['title']),
                subtitle: Text(
                  "${n['body']}\n${DateFormat('yyyy-MM-dd HH:mm').format(ts.toDate())}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
