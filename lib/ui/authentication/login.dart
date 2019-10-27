import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/views/login_view_model.dart';
import 'package:familytree/ui/authentication/login-ui/login_footer.dart';
import 'package:familytree/ui/authentication/login-ui/login_form.dart';
import 'package:familytree/ui/authentication/login-ui/login_header.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegExp emailRegExp = new RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  void _authenticate(Function loginUser, String error) async {
    var keyState = _formKey.currentState;
    if (keyState.validate()) {
      keyState.save();
      FirebaseUser user = await loginUser();
      if (user != null) {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.Home,
          arguments: user.uid,
        );
      } else {
        Toast.show(
          error,
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                  child: Container(
                    height: screenSize.height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        LoginHeader(),
                        LoginForm(
                          setEmail: model.setEmail,
                          setPassword: model.setPassword,
                        ),
                        Container(
                          width: screenSize.width * 0.5,
                          height: screenSize.height * 0.05,
                          child: RaisedButton(
                            color: ColorPalette.blueSapphireColor,
                            onPressed: () => _authenticate(model.loginUser, model.error),
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
                        ),
                        LoginFooter(),
                      ],
                    ),
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
