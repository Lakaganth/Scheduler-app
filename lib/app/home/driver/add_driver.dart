import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/model/driver_model.dart';
import 'package:scheduler/common/form_submit_button.dart';
import 'package:scheduler/common/platform_exception_alert_dialog.dart';
import 'package:scheduler/services/auth.dart';
import 'package:scheduler/services/driver_database.dart';

class AddNewDriver extends StatefulWidget {
  AddNewDriver(
      {@required this.driverDatabase, @required this.auth, this.driver});

  final DriverDatabase driverDatabase;
  final Driver driver;
  final AuthBase auth;

  static Future<void> show(BuildContext context,
      {DriverDatabase driverDatabase, Driver driver, AuthBase auth}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewDriver(
          driverDatabase: driverDatabase,
          auth: auth,
          driver: driver,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddNewDriverState createState() => _AddNewDriverState();
}

class _AddNewDriverState extends State<AddNewDriver> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    // final driverDatabase = Provider.of<DriverDatabase>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        final authResult =
            await auth.createUserWithEmailAndPassword(_email.trim(), _password);
        final newDriver =
            Driver(id: authResult.uid, name: _name, email: _email);
        await widget.driverDatabase.setNewDriver(newDriver);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(title: 'Operation Failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Driver"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormColumnChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildFormColumnChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Driver Name',
        ),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Driver Email',
        ),
        initialValue: _email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        initialValue: _password,
        validator: (value) =>
            value.isNotEmpty ? null : 'Password can\'t be empty',
        onSaved: (value) => _password = value,
      ),
      SizedBox(
        height: 16.0,
      ),
      FormSubmitButton(
        text: "Submit",
        onPressed: () => _submit(),
      )
    ];
  }
}
