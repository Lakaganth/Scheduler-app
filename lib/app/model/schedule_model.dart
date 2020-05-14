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
  });

  String id;
  String driverId;
  DateTime shiftDate;
  String shiftType;
  int weekNumber;
  int shiftHours;

  factory DaySchedule.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String driverId = data['driverId'];
    final DateTime shiftDate = (data['shiftDate'] as Timestamp).toDate();

    final String shiftType = data['shiftType'];
    final int weekNumber = data['weekNumber'];
    final int shiftHours = data['shiftHours'];

    return DaySchedule(
      id: documentId,
      driverId: driverId,
      shiftDate: shiftDate,
      shiftType: shiftType,
      weekNumber: weekNumber,
      shiftHours: shiftHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'shiftDate': shiftDate,
      'shiftType': shiftType,
      'weekNumber': weekNumber,
      'shiftHours': shiftHours,
    };
  }
}
