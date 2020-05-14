import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/sign_in/sigin_in_form.dart';
import 'package:scheduler/app/sign_in/signin_manager.dart';
import 'package:scheduler/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({@required this.manager, @required this.isLoading});
  final SigninManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SigninManager>(
          create: (_) => SigninManager(auth: auth, isLoading: isLoading),
          child: Consumer<SigninManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/Login_Avatar.png',
                height: 200,
                width: 200,
              ),
              SignInForm.create(context),
            ],
          ),
        ),
      ),
    );
  }
}
