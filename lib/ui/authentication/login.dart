import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/views/login_view_model.dart';
import 'package:familytree/ui/authentication/login-ui/login_footer.dart';
import 'package:familytree/ui/authentication/login-ui/login_form.dart';
import 'package:familytree/ui/authentication/login-ui/login_header.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegExp emailRegExp = new RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  void _authenticate() {
    var keyState = _formKey.currentState;
    if (keyState.validate()) {
      keyState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel>(
      model: LoginViewModel(firebaseAuth: new FirebaseAuthProvider()),
      builder: (context, model, child) => Scaffold(
          body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      LoginHeader(),
                      LoginForm(
                        setEmail: model.setEmail,
                        setPassword: model.setPassword,
                      ),
                      RaisedButton(
                        color: Colors.green,
                        onPressed: _authenticate,
                        child: Text(
                          'Log Masuk',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                          ),
                        ),
                      ),
                      LoginFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          model.busy ? LoadingOverlay() : Container(),
        ],
      )),
    );
  }
}
