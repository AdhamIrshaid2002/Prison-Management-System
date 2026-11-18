
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:police/Prisoner/notaion.dart';

class NotificationCheckerService {
  static Future<void> checkAllPrisoners() async {
    final now = DateTime.now();

    final categories = await FirebaseFirestore.instance
        .collection("categories")
        .get();

    for (var category in categories.docs) {
      final rooms = await FirebaseFirestore.instance
          .collection("categories")
          .doc(category.id)
          .collection("rooms")
          .get();

      for (var room in rooms.docs) {
        final prisoners = await FirebaseFirestore.instance
            .collection("categories")
            .doc(category.id)
            .collection("rooms")
            .doc(room.id)
            .collection("prisoners")
            .get();

        for (var p in prisoners.docs) {
          final data = p.data();

          final name = data["name"];
          final releaseDate =
              (data["releaseDate"] as Timestamp?)?.toDate();

          final visitDay = data["visitDay"];
          final visitTimeStr = data["visitTime"];

          if (releaseDate != null) {
            await _checkReleaseDate(
              p.id,
              name,
              releaseDate,
              now,
            );
          }

          if (visitDay != null && visitTimeStr != null) {
            await _checkVisitDate(
              p.id,
              name,
              visitDay,
              visitTimeStr,
              now,
            );
          }
        }
      }
    }
  }

  static Future<void> _checkReleaseDate(
    String prisonerId,
    String name,
    DateTime releaseDate,
    DateTime now,
  ) async {
    final diff = releaseDate.difference(now);

    if (diff.inMinutes <= 60 && diff.inMinutes > 0) {
      await NotificationService.sendAndSave(
        prisonerId: prisonerId,
        title: "Release in One Hour",
        body: "One hour remains until prisoner $name is released",
        scheduledAt:
            releaseDate.subtract(const Duration(hours: 1)),
        type: "release_1h",
      );
    }

    if (diff.inDays == 1) {
      await NotificationService.sendAndSave(
        prisonerId: prisonerId,
        title: "Release Tomorrow",
        body: "Prisoner $name will be released tomorrow",
        scheduledAt:
            releaseDate.subtract(const Duration(days: 1)),
        type: "release_1d",
      );
    }
  }

  static Future<void> _checkVisitDate(
    String prisonerId,
    String name,
    String visitDay,
    String visitTimeStr,
    DateTime now,
  ) async {
    final parts = visitTimeStr.split(":");

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final visitDate = _getNextVisitDate(
      visitDay,
      hour,
      minute,
      now,
    );

    final diff = visitDate.difference(now);

    if (diff.inMinutes <= 60 && diff.inMinutes > 0) {
      await NotificationService.sendAndSave(
        prisonerId: prisonerId,
        title: "Visit in One Hour",
        body: "One hour remains until prisoner $name's visit",
        scheduledAt:
            visitDate.subtract(const Duration(hours: 1)),
        type: "visit_1h",
      );
    }

    if (visitDate.year == now.year &&
        visitDate.month == now.month &&
        visitDate.day == now.day &&
        visitDate.hour == now.hour &&
        visitDate.minute == now.minute) {
      await NotificationService.sendAndSave(
        prisonerId: prisonerId,
        title: "Visit Now",
        body: "It is time to visit prisoner $name",
        scheduledAt: visitDate,
        type: "visit_now",
      );
    }
  }

  static DateTime _getNextVisitDate(
    String dayOfWeek,
    int hour,
    int minute,
    DateTime now,
  ) {
    Map<String, int> days = {
      "Monday": DateTime.monday,
      "Tuesday": DateTime.tuesday,
      "Wednesday": DateTime.wednesday,
      "Thursday": DateTime.thursday,
      "Friday": DateTime.friday,
      "Saturday": DateTime.saturday,
      "Sunday": DateTime.sunday,
    };

    int targetWeekday = days[dayOfWeek]!;

    DateTime visitDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (
        visitDate.weekday != targetWeekday ||
        visitDate.isBefore(now)) {
      visitDate = visitDate.add(
        const Duration(days: 1),
      );
    }

    return visitDate;
  }
}

