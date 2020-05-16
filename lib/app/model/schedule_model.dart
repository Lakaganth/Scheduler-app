import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum ShiftType { A, B, C }

class DaySchedule {
  DaySchedule({
    @required this.id,
    @required this.driverId,
    @required this.shiftDate,
    @required this.shiftType,
    @required this.weekNumber,
    @required this.shiftHours,
    this.loginTime,
    this.lunchTime,
  });

  String id;
  String driverId;
  DateTime shiftDate;
  String shiftType;
  int weekNumber;
  int shiftHours;
  DateTime loginTime;
  DateTime lunchTime;

  factory DaySchedule.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String driverId = data['driverId'];
    final DateTime shiftDate = (data['shiftDate'] as Timestamp).toDate();
    final String shiftType = data['shiftType'];
    final int weekNumber = data['weekNumber'];
    final int shiftHours = data['shiftHours'];
    final int loginTime = data['loginTime'];
    final int lunchTime = data['lunchTime'];

    return DaySchedule(
      id: documentId,
      driverId: driverId,
      shiftDate: shiftDate,
      shiftType: shiftType,
      weekNumber: weekNumber,
      shiftHours: shiftHours,
      loginTime: loginTime != null
          ? DateTime.fromMillisecondsSinceEpoch(loginTime)
          : null,
      lunchTime: lunchTime != null
          ? DateTime.fromMillisecondsSinceEpoch(lunchTime)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    if (loginTime != null && lunchTime == null) {
      return {
        'driverId': driverId,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime.millisecondsSinceEpoch,
        // 'lunchTime': null,
      };
    } else if (lunchTime != null) {
      return {
        'driverId': driverId,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime.millisecondsSinceEpoch,
        'lunchTime': lunchTime.millisecondsSinceEpoch,
      };
    } else {
      return {
        'driverId': driverId,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
      };
    }
  }
}
