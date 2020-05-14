import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/home/driver/empty_content.dart';
import 'package:scheduler/app/model/driver_model.dart';
import 'package:scheduler/app/model/schedule_model.dart';
import 'package:scheduler/services/schedule_database.dart';
import 'package:table_calendar/table_calendar.dart';

class DriverSchedulePage extends StatefulWidget {
  DriverSchedulePage({@required this.driver});

  final Driver driver;

  static Future<void> show(BuildContext context,
      {@required Driver driver}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DriverSchedulePage(
          driver: driver,
        ),
      ),
    );
  }

  @override
  _DriverSchedulePageState createState() => _DriverSchedulePageState();
}

class _DriverSchedulePageState extends State<DriverSchedulePage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<DaySchedule> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = event.shiftDate;
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final scheduleDatabe =
        Provider.of<ScheduleDatabase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driver.name),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
          stream: scheduleDatabe.scheduleStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("Error!, ${snapshot.error}");
            } else if (snapshot.data == null) {
              return new EmptyContent();
            } else {
              List<DaySchedule> items = snapshot.data;
              return Container(child: _buildChildrenWithCalendar(items));
            }
          },
        ),
      ),
    );
  }

  Widget _buildChildrenWithCalendar(List<DaySchedule> items) {
    _events = _groupEvents(items);
    print(_selectedEvents);
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            calendarController: _controller,
            events: _events,
            initialCalendarFormat: CalendarFormat.twoWeeks,
            calendarStyle: CalendarStyle(
              canEventMarkersOverflow: true,
              todayColor: Colors.orange,
              selectedColor: Theme.of(context).primaryColor,
              markersColor: Colors.white,
              todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white),
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: (date, events) {
              setState(() {
                _selectedEvents = events;
              });
            },
          ),
          ..._selectedEvents.map(
            (event) => ListTile(
              title: Text(
                "Hours: ${event.shiftHours.toString()}",
                style: TextStyle(fontSize: 22.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
