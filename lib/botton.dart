import 'package:flutter/material.dart';
import 'package:police/Prisoner/NotificationsPage.dart';

class BottomNav extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onVisitsPressed;

  const BottomNav({
    super.key,
    required this.onHomePressed,
    required this.onVisitsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: onHomePressed,
            icon: Icon(Icons.home, color: Colors.blue, size: 30),
          ),
          IconButton(
  icon: Icon(Icons.notifications,color: Colors.blue, size: 30),
  onPressed: () {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(
          
        ),
      ),
    );
  },
)

        ],
      ),
    );
  }
}
