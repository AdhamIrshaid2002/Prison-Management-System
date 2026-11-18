import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:police/Prisoner/checked.dart';
import 'package:police/Prisoner/notaion.dart';
import 'package:police/auth/login.dart';
import 'package:police/auth/signup.dart';
import 'package:police/deparment/adddept.dart';
import 'package:police/home.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz; 
import 'package:timezone/timezone.dart' as tz;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    tz.initializeTimeZones();
    await NotificationService.init();

    
    await NotificationCheckerService.checkAllPrisoners();

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await NotificationService.init();

 
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    "checkPrisonersTask",
    "checkPrisoners",
    frequency: const Duration(minutes: 15),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPeriodicCheck();
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is signed out');
      } else {
        print('User is signed in');
      }
    });
  }

  void _startPeriodicCheck() {
    
    Future.doWhile(() async {
      await NotificationCheckerService.checkAllPrisoners();
      await Future.delayed(const Duration(minutes: 1));
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,

  home: StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (snapshot.hasData) {
        return Home();
      }

      return Login();
    },
  ),

  routes: {
    'signup': (context) => Signup(),
    'home': (context) => Home(),
    'login': (context) => Login(),
    'adddep': (context) => Adddept(),
    'app': (context) => MyApp(),
  },
);
  }
}
