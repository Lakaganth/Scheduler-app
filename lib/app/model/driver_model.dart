import 'package:flutter/foundation.dart';

class Driver {
  Driver({
    @required this.id,
    @required this.name,
    @required this.email,
  });

  String id;
  String name;
  String email;

  factory Driver.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final String email = data['email'];

    return Driver(
      id: documentId,
      name: name,
      email: email,
    );
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }
}
