import 'dart:async';
import 'package:meta/meta.dart';
import 'package:scheduler/app/model/login_model.dart';
import 'package:scheduler/services/api_path.dart';
import 'package:scheduler/services/firestore_service.dart';

abstract class LoginDatabase {
  Future<void> setNewSchedule(DriverLoginModel driverLogin);
}

class LoginFirestoreDatabase implements LoginDatabase {
  final _service = FirestoreService.instance;

  @override
  Future<void> setNewSchedule(DriverLoginModel driverLogin) async {
    return await _service.setData(
        path: APIPath.dailyDriverLogin(driverLogin.id),
        data: driverLogin.toMap());
  }
}
