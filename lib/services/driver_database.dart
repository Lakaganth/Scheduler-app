import 'dart:async';
import 'package:meta/meta.dart';
import 'package:scheduler/app/model/driver_model.dart';
import 'package:scheduler/services/api_path.dart';
import 'package:scheduler/services/firestore_service.dart';

abstract class DriverDatabase {
  Future<void> setNewDriver(Driver driver);
  Stream<List<Driver>> driverStream();
}

class DriveFirestoreDatabase implements DriverDatabase {
  final _service = FirestoreService.instance;

  @override
  Future<void> setNewDriver(Driver driver) async {
    return await _service.setData(
        path: APIPath.driver(driver.id), data: driver.toMap());
  }

  @override
  Stream<List<Driver>> driverStream() => _service.collectionStream(
        path: APIPath.drivers(),
        builder: (data, documentId) => Driver.fromMap(data, documentId),
      );
}
