import 'package:flutter/cupertino.dart';
import 'package:scheduler/common/validators.dart';
import 'package:scheduler/services/auth.dart';

class SigninModel with EmailAndPasswordValidators, ChangeNotifier {
  SigninModel(
      {this.email = '',
      this.password = '',
      this.isLoading = false,
      this.submitted = false,
      @required this.auth});

  String email;
  String password;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? emailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  void updateWith(
      {String email, String password, bool isLoading, bool submitted}) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void updateEmail(String email) => updateWith(email: email.trim());

  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signinWithEmailAndPassword(this.email, this.password);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
