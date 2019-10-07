import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/views/root_view_model.dart';
import 'package:familytree/ui/authentication/login.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/main/home.dart';
import 'package:familytree/ui/splash.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RootViewModel>(
      model: RootViewModel(
        firebaseAuthProvider: new FirebaseAuthProvider(),
      ),
      onModelReady: (model) => model.initializeLogin(),
      builder: (context, model, child) => model.busy
          ? SplashScreen()
          : model.user?.uid == null ? LoginScreen() : HomeScreen(),
    );
  }
}
