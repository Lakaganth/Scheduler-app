import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/home/driver/add_driver.dart';
import 'package:scheduler/app/home/driver/driver_listtile.dart';
import 'package:scheduler/app/home/driver/driver_schedule_page.dart';
import 'package:scheduler/app/home/driver/list_items_builder.dart';
import 'package:scheduler/app/home/schedule/add_new_day_schedule.dart';
import 'package:scheduler/app/model/driver_model.dart';
import 'package:scheduler/services/auth.dart';
import 'package:scheduler/services/driver_database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AllDriverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drivers"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => AddNewDriver.show(
              context,
              driverDatabase:
                  Provider.of<DriverDatabase>(context, listen: false),
              auth: Provider.of<AuthBase>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final driverDatabase = Provider.of<DriverDatabase>(context);
    return StreamBuilder<List<Driver>>(
        stream: driverDatabase.driverStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder(
            snapshot: snapshot,
            itemBuilder: (context, driver) => Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Update',
                  color: Colors.blue,
                  icon: Icons.update,
                  onTap: () => {},
                ),
                IconSlideAction(
                  caption: 'Add',
                  color: Colors.indigo,
                  icon: Icons.schedule,
                  onTap: () => AddNewDaySchedule.show(
                    context,
                    driver: driver,
                  ),
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'More',
                  color: Colors.black45,
                  icon: Icons.more_horiz,
                  // onTap: () => _showSnackBar('More'),
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  // onTap: () => _showSnackBar('Delete'),
                ),
              ],
              child: DriverListTile(
                driver: driver,
                // onTap: () => print("Here is Error"),
                onTap: () => DriverSchedulePage.show(context, driver: driver),
              ),
            ),
          );
        });
  }
}
