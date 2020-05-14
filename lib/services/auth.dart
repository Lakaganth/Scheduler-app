import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Future<User> signinWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Stream<User> get onAuthStateChanged;
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

// Converts Firebase User to Generic User
  User _userFromFrirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

// Signin with Email and Password
  @override
  Future<User> signinWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFrirebase(authResult.user);
  }

  //  Register New user
  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFrirebase(authResult.user);
  }

// SignOut
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

//Stream to get User activity

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFrirebase);
  }

  //Get the Current User
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFrirebase(user);
  }
}
