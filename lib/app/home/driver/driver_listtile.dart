import 'package:flutter/material.dart';
import 'package:scheduler/app/model/driver_model.dart';

class DriverListTile extends StatelessWidget {
  final Driver driver;
  final VoidCallback onTap;
  DriverListTile({@required this.driver, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(driver.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
