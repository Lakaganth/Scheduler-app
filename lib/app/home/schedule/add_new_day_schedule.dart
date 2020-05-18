import 'dart:async';

import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/home/driver/empty_content.dart';
import 'package:scheduler/app/model/driver_model.dart';
import 'package:scheduler/app/model/schedule_model.dart';
import 'package:scheduler/common/form_submit_button.dart';
import 'package:scheduler/services/schedule_database.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AddNewDaySchedule extends StatefulWidget {
  AddNewDaySchedule({@required this.driver});

  final Driver driver;

  static Future<void> show(BuildContext context,
      {@required Driver driver}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewDaySchedule(
          driver: driver,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddNewDayScheduleState createState() => _AddNewDayScheduleState();
}

class _AddNewDayScheduleState extends State<AddNewDaySchedule> {
  CalendarController _calendarController;
  DateTime date = DateTime.now();
  int selectedDateWeekNumber;
  int totalHours = 0;
  int remainingHours = 60;
  ShiftType shiftType;
  int shiftHours;
  Color unSelectedShift = Colors.orange;
  var dateUtility;
  int totalHoursStream;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  String scheduleId() => '${date}+${widget.driver.id}';

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    selectedDateWeekNumber = weekNumber(date);
    _events = {};
    _selectedEvents = [];
    dateUtility = new DateUtil();
  }

  @override
  void dispose() {
    _calendarController.dispose();

    super.dispose();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
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

  _submit() async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);

    final DaySchedule schedule = DaySchedule(
        id: scheduleId(),
        driverId: widget.driver.id,
        driverName: widget.driver.name,
        shiftDate: date,
        shiftType: shiftType.toString(),
        weekNumber: selectedDateWeekNumber,
        shiftHours: shiftHours);
    await scheduleDatabase.setNewSchedule(schedule);
  }

  @override
  Widget build(BuildContext context) {
    // print("totalHoursStream $totalHoursStream");
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    return StreamBuilder(
        stream: scheduleDatabase.weeksHoursStream(widget.driver),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            totalHoursStream = 0;
            List<DaySchedule> items = snapshot.data;
            items.forEach(
              (item) {
                if (item.weekNumber == selectedDateWeekNumber) {
                  totalHoursStream = item.shiftHours + totalHoursStream;
                }
                // print("Hello $totalHoursStream");
              },
            );

            _events = _groupEvents(items);
            return Scaffold(
              appBar: AppBar(
                title: Text("Add Schedule"),
                backgroundColor: Colors.indigo,
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Card(
                    color: Colors.white10,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: _buildForm(),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  Form _buildForm() {
    return Form(
      child: Column(
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    // print("Selected Date: $date and week number: $selectedDateWeekNumber,");
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Driver Name',
        ),
        initialValue: widget.driver.name,
      ),
      SizedBox(
        height: 32.0,
      ),
      TableCalendar(
        calendarController: _calendarController,
        events: _events,
        startingDayOfWeek: StartingDayOfWeek.monday,
        initialCalendarFormat: CalendarFormat.twoWeeks,
        calendarStyle: CalendarStyle(
          canEventMarkersOverflow: true,
          todayColor: Colors.orange,
          selectedColor: Colors.purple,
          markersColor: Colors.white,
          todayStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        onDaySelected: (day, events) {
          setState(() {
            date = day;
            selectedDateWeekNumber = weekNumber(day);
            _selectedEvents = events;
          });
        },
      ),
      SizedBox(
        height: 32.0,
      ),
      _selectShift(),
      SizedBox(
        height: 32.0,
      ),
      Text(
        "Hours for the week : $totalHoursStream",
        style: TextStyle(fontSize: 24.0),
      ),
      Text(
        "Hours for the week : ${60 - totalHoursStream} ",
        style: TextStyle(fontSize: 24.0),
      ),
      SizedBox(
        height: 32.0,
      ),
      FormSubmitButton(
        text: "Save",
        onPressed: totalHoursStream > 60 ? null : _submit,
      )
    ];
  }

  Widget _selectShift() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Select Shift",
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: totalHoursStream >= 51
                  ? null
                  : () {
                      setState(() {
                        shiftType = ShiftType.A;
                        shiftHours = 10;
                      });
                    },
              color: shiftType == ShiftType.A ? Colors.green : null,
              child: Text("A"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            RaisedButton(
              onPressed: totalHoursStream >= 53
                  ? null
                  : () {
                      setState(() {
                        shiftType = ShiftType.B;
                        shiftHours = 8;
                      });
                    },
              color: shiftType == ShiftType.B ? Colors.green : null,
              child: Text("B"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            RaisedButton(
              onPressed: totalHoursStream > 55
                  ? null
                  : () {
                      setState(() {
                        shiftType = ShiftType.C;
                        shiftHours = 5;
                      });
                    },
              color: shiftType == ShiftType.C ? Colors.green : null,
              child: Text("C"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
