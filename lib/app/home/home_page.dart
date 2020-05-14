import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/home/driver/add_driver.dart';
import 'package:scheduler/app/home/driver/all_drivers.dart';

import 'package:scheduler/services/auth.dart';
import 'package:scheduler/services/driver_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _buildChildren(AuthBase auth, DriverDatabase driverDatabase) {
    return [
      FlatButton(
        child: Text("All Drivers"),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => AllDriverList()));
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final driverDatabase = Provider.of<DriverDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Scheduler"),
        centerTitle: true,
        actions: [FlatButton(onPressed: auth.signOut, child: Text("Log out"))],
      ),
      body: Column(
        children: _buildChildren(auth, driverDatabase),
      ),
    );
  }
}
