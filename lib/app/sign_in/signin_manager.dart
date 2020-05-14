import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:scheduler/services/auth.dart';

class SigninManager {
  SigninManager({@required this.auth, @required this.isLoading});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signinMethod) async {
    try {
      isLoading.value = true;
      return await signinMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }
}
