import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/landing_page.dart';
import 'package:scheduler/services/auth.dart';
import 'package:scheduler/services/driver_database.dart';
import 'package:scheduler/services/login_database.dart';
import 'package:scheduler/services/schedule_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DriverDatabase>(
          create: (context) => DriveFirestoreDatabase(),
        ),
        Provider<AuthBase>(
          create: (context) => Auth(),
        ),
        Provider<ScheduleDatabase>(
          create: (context) => ScheduleFirestoreDatabase(),
        ),
        Provider<LoginDatabase>(
          create: (context) => LoginFirestoreDatabase(),
        )
      ],
      child: MaterialApp(
        title: "Scheduler App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        home: LandingPage(),
      ),
    );
  }
}
