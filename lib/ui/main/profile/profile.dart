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
    final screenSize = MediaQuery.of(context).size;

    return BaseWidget<ProfileViewModel>(
      model: ProfileViewModel(
        firestore: Firestore.instance,
        firebaseAuth: FirebaseAuth.instance,
      ),
      builder: (context, model, child) => Stack(
        children: <Widget>[
          Container(
            width: screenSize.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.microsoft.com/en-us/research/wp-content/uploads/2017/09/avatar_user_36443_1506533427.jpg'),
                    radius: screenSize.height * 0.07,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: screenSize.height * 0.19,
            left: screenSize.width * 0.5,
            child: Container(
              child: RaisedButton(
                child: Icon(
                  Icons.camera_alt,
                  color: ColorPalette.teaGreenColor,
                ),
                onPressed: () => model.logOut(),
                color: ColorPalette.oceanGreenColor,
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
