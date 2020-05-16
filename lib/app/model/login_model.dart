class DriverLoginModel {
  DriverLoginModel({
    this.id,
    this.driverId,
    this.scheduleId,
    this.loginTime,
    this.lunchTime,
  });

  String id;
  String driverId;
  String scheduleId;
  DateTime loginTime;
  DateTime lunchTime;

  factory DriverLoginModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String driverId = data['driverId'];
    final String scheduleId = data['scheduleId'];
    final int loginTime = data['loginTime'];
    final int lunchTime = data['lunchTime'];

    return DriverLoginModel(
      id: documentId,
      driverId: driverId,
      scheduleId: scheduleId,
      loginTime: DateTime.fromMillisecondsSinceEpoch(loginTime),
      lunchTime: DateTime.fromMillisecondsSinceEpoch(lunchTime),
    );
  }
  Map<String, dynamic> toMap() {
    if (loginTime != null) {
      return {
        'driverId': driverId,
        'scheduleId': scheduleId,
        'loginTime': loginTime.millisecondsSinceEpoch,
      };
    } else {
      return {
        'driverId': driverId,
        'scheduleId': scheduleId,
        'lunchTime': lunchTime.millisecondsSinceEpoch
      };
    }

    // return {
    //   'driverId': driverId,
    //   'scheduleId': scheduleId,
    //   'loginTime': loginTime.millisecondsSinceEpoch,
    //   'lunchTime': lunchTime.millisecondsSinceEpoch
    // };
  }
}
