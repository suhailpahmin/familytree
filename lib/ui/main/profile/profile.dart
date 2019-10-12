import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/viewmodels/views/profile_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ProfileViewModel>(
      model: ProfileViewModel(
        firestore: Firestore.instance,
        firebaseAuth: FirebaseAuth.instance,
      ),
      builder: (context, model, child) => Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: ColorPalette.blueSapphireColor,
                child: Text(
                  'Log Keluar',
                  style: TextStyle(
                    color: ColorPalette.teaGreenColor,
                  ),
                ),
                onPressed: () {
                  model.logOut();
                  Navigator.pushReplacementNamed(context, RoutePaths.Root);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
