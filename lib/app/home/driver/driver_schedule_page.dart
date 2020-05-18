import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:scheduler/app/model/driver_model.dart';

import 'package:scheduler/app/model/schedule_model.dart';

import 'package:scheduler/services/schedule_database.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

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
  DateTime todayDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool hasLoggedIn = false;
  bool finishedLunch = false;
  DateTime currentLoginTime;

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

  void _todayLogin(DaySchedule schedule, var onlyTodayDate) async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    print("Login time ${DateTime.now()} , The id to be changed ${schedule.id}");
    setState(() {
      currentLoginTime = DateTime.now();
      hasLoggedIn = true;
    });
    DaySchedule todayLogin = DaySchedule(
      id: schedule.id,
      driverId: schedule.driverId,
      driverName: widget.driver.name,
      shiftDate: schedule.shiftDate,
      shiftHours: schedule.shiftHours,
      shiftType: schedule.shiftType,
      weekNumber: schedule.weekNumber,
      loginTime: currentLoginTime,
      lunchTime: null,
    );
    await scheduleDatabase.setNewSchedule(todayLogin);
  }

  void _todayLunch(DaySchedule schedule, var onlyTodayDate) async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    DaySchedule todayLogin = DaySchedule(
      id: schedule.id,
      driverId: schedule.driverId,
      driverName: widget.driver.name,
      shiftDate: schedule.shiftDate,
      shiftHours: schedule.shiftHours,
      shiftType: schedule.shiftType,
      weekNumber: schedule.weekNumber,
      loginTime: currentLoginTime,
      lunchTime: DateTime.now(),
      eod: true,
    );
    await scheduleDatabase.setNewSchedule(todayLogin);
    setState(() {
      finishedLunch = true;
    });
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<DaySchedule> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = event.shiftDate;
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    // print(data);
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
        child: SingleChildScrollView(
            child: StreamBuilder(
          stream: scheduleDatabe.weeksHoursStream(widget.driver),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.active) {
              List<DaySchedule> items = snapshots.data;
              if (snapshots.hasData) {
                return _buildChildrenWithCalendar(items);
              }
              return Container(
                child: Text("No Data"),
              );
            } else if (snapshots.connectionState == ConnectionState.waiting) {
              return Container(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.warning),
                    ),
                    Text('Error in loadind data')
                  ],
                ),
              );
            }
          },
        )),
      ),
    );
  }

  Widget _buildChildrenWithCalendar(List<DaySchedule> items) {
    _events = _groupEvents(items);

    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            calendarController: _controller,
            events: _events,
            initialCalendarFormat: CalendarFormat.twoWeeks,
            calendarStyle: CalendarStyle(
              canEventMarkersOverflow: true,
              // todayColor: Colors.orange,
              selectedColor: Colors.purple,
              markersColor: Colors.lime,
              todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white),
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: (date, events) {
              setState(() {
                _selectedEvents = events;
                _selectedDate = date;
              });
            },
          ),
          SizedBox(
            height: 32.0,
          ),
          ..._selectedEvents.map((event) {
            if (event.driverId == widget.driver.id) {
              return ListTile(
                title: Text(
                  "Hours: ${event.shiftHours.toString()}",
                  style: TextStyle(fontSize: 22.0),
                ),
              );
            } else {
              return ListTile(
                title: Text(''),
              );
            }
          }),
          _buildLoginButtonGroup(items),
          _displaytimers(items),
        ],
      ),
    );
  }

  Widget _buildLoginButtonGroup(List<DaySchedule> items) {
    Widget buttonLogin;
    List<DaySchedule> todaySchedule = items.where((e) {
      var onlyTodayDate = DateFormat('d-MM-yyyy').format(todayDate);
      var onlyElementDate = DateFormat('d-MM-yyyy').format(e.shiftDate);
      return onlyTodayDate == onlyElementDate;
    }).toList();

    todaySchedule.forEach(
      (element) {
        var onlyStreamDate = DateFormat('d-MM-yyyy').format(_selectedDate);
        var onlyTodayDate = DateFormat('d-MM-yyyy').format(todayDate);
        !element.eod
            ? buttonLogin = onlyTodayDate == onlyStreamDate
                ? Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: RaisedButton(
                            onPressed: !hasLoggedIn
                                ? () => _todayLogin(element, onlyTodayDate)
                                : null,
                            child: Text("Login"),
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text('')
            : buttonLogin = Text('');
      },
    );

    return buttonLogin;
  }

  _displaytimers(List<DaySchedule> items) {
    if (currentLoginTime != null) {
      DateTime lunchStartTime =
          currentLoginTime?.add(Duration(seconds: 10)) ?? null;

      List<DaySchedule> todaySchedule = items.where((e) {
        var onlyTodayDate = DateFormat('d-MM-yyyy').format(todayDate);
        var onlyElementDate = DateFormat('d-MM-yyyy').format(e.shiftDate);
        return onlyTodayDate == onlyElementDate;
      }).toList();

      return TimerBuilder.scheduled([currentLoginTime, lunchStartTime],
          builder: (context) {
        final now = DateTime.now();
        final started = now.compareTo(currentLoginTime) >= 0;
        final ended = now.compareTo(lunchStartTime) >= 0;
        return started
            ? ended
                ? _showLunchButton(todaySchedule)
                : _startTimer(lunchStartTime)
            : Text("Not Started");
      });
    }
    return Text('');
  }

  _startTimer(lunchStartTime) {
    return Center(
      child: CircularCountDownTimer(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 3,
        duration: 10,
        fillColor: Colors.red,
        color: Colors.white,
        strokeWidth: 5.0,
      ),
    );
  }

  _showLunchButton(List<DaySchedule> todaySchedule) {
    Widget lunchButton;
    var onlyTodayDate = DateFormat('d-MM-yyyy').format(todayDate);
    todaySchedule.forEach((element) {
      lunchButton = Padding(
        padding: const EdgeInsets.all(32.0),
        child: RaisedButton(
          onPressed: hasLoggedIn && !finishedLunch
              ? () => _todayLunch(element, onlyTodayDate)
              : null,
          child: Text("Lunch"),
          color: Colors.orange,
        ),
      );
    });

    return lunchButton;
  }
}
