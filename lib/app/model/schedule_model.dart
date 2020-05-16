import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum ShiftType { A, B, C }

class DaySchedule {
  DaySchedule({
    @required this.id,
    @required this.driverId,
    @required this.driverName,
    @required this.shiftDate,
    @required this.shiftType,
    @required this.weekNumber,
    @required this.shiftHours,
    this.loginTime,
    this.lunchTime,
    this.eod = false,
  });

  String id;
  String driverId;
  String driverName;
  DateTime shiftDate;
  String shiftType;
  int weekNumber;
  int shiftHours;
  DateTime loginTime;
  DateTime lunchTime;
  bool eod;

  factory DaySchedule.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String driverId = data['driverId'];
    final String driverName = data['driverName'];
    final int shiftDate = data['shiftDate'];
    final String shiftType = data['shiftType'];
    final int weekNumber = data['weekNumber'];
    final int shiftHours = data['shiftHours'];
    final int loginTime = data['loginTime'];
    final int lunchTime = data['lunchTime'];
    final bool eod = data['eod'];

    return DaySchedule(
      id: documentId,
      driverId: driverId,
      driverName: driverName,
      shiftDate: DateTime.fromMillisecondsSinceEpoch(shiftDate),
      shiftType: shiftType,
      weekNumber: weekNumber,
      shiftHours: shiftHours,
      loginTime: loginTime != null
          ? DateTime.fromMillisecondsSinceEpoch(loginTime)
          : null,
      lunchTime: lunchTime != null
          ? DateTime.fromMillisecondsSinceEpoch(lunchTime)
          : null,
      eod: eod,
    );
  }

  Map<String, dynamic> toMap() {
    if (loginTime != null && lunchTime == null) {
      return {
        'driverId': driverId,
        'driveName': driverName,
        'shiftDate': shiftDate.millisecondsSinceEpoch,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime.millisecondsSinceEpoch,
        'eod': eod
        // 'lunchTime': null,
      };
    } else if (lunchTime != null) {
      return {
        'driverId': driverId,
        'driveName': driverName,
        'shiftDate': shiftDate.millisecondsSinceEpoch,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime.millisecondsSinceEpoch,
        'lunchTime': lunchTime.millisecondsSinceEpoch,
        'eod': eod
      };
    } else {
      return {
        'driverId': driverId,
        'driveName': driverName,
        'shiftDate': shiftDate.millisecondsSinceEpoch,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'eod': eod
      };
    }
  }
}
