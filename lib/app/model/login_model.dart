class DriverLoginModel {
  DriverLoginModel({
    this.loginTime,
    this.lunchTime,
  });

  DateTime loginTime;
  DateTime lunchTime;

  factory DriverLoginModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final int loginTime = data['loginTime'];
    final int lunchTime = data['lunchTime'];

    return DriverLoginModel(
        loginTime: DateTime.fromMillisecondsSinceEpoch(loginTime),
        lunchTime: DateTime.fromMillisecondsSinceEpoch(lunchTime));
  }
  Map<String, dynamic> toMap() {
    return {
      'loginTime': loginTime.millisecondsSinceEpoch,
      'lunchTime': lunchTime.millisecondsSinceEpoch
    };
  }
}
