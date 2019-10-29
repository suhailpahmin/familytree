import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/views/other_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/main/family/family-ui/new_family_dialog.dart';
import 'package:familytree/ui/main/pictories/pictories_from_others.dart';
import 'package:familytree/ui/main/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class OthersScreen extends StatefulWidget {
  const OthersScreen({Key key}) : super(key: key);

  @override
  _OthersScreenState createState() => _OthersScreenState();
}

class _OthersScreenState extends State<OthersScreen> {
  Future _openNewFamilyDialog(
      Function(FamilyData newMember) addFamilyMember) async {
    var route = MaterialPageRoute<FamilyData>(
      builder: (BuildContext context) => new NewFamilyDialog(),
      fullscreenDialog: true,
    );
    FamilyData data = await Navigator.of(context).push(route);
    if (data != null) {
      addFamilyMember(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BaseWidget<OtherViewModel>(
      model: OtherViewModel(
        firebaseAuth: FirebaseAuth.instance,
        firestore: Firestore.instance,
        userID: Provider.of<User>(context).id,
      ),
      onModelReady: (model) => model.getFamilyID(),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              color: ColorPalette.blueSapphireColor,
              child: ListTile(
                title: Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.04,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (BuildContext context) => new ProfileScreen(
                          userID: null,
                        ));
                Navigator.push(context, route);
              },
            ),
            ListTile(
              title: Text(
                'Pictories',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new PictoriesFromOthers());
                Navigator.push(context, route);
              },
            ),
            model.familyID != null
                ? ListTile(
                    title: Text(
                      'Invites',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => _openNewFamilyDialog(model.addFamilyMember),
                  )
                : Container(),
            ListTile(
              title: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Toast.show('This feature is currently unavailable', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            Container(
              color: ColorPalette.blueSapphireColor,
              child: ListTile(
                title: Text(
                  'Help & Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.04,
                  ),
                ),
                onTap: () {
                  Toast.show('This feature is currently unavailable', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                },
              ),
            ),
            ListTile(
              title: Text(
                'FAQ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Toast.show('This feature is currently unavailable', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            ListTile(
              title: Text(
                'Terms & Conditions',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Toast.show('This feature is currently unavailable', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            Container(
              color: ColorPalette.blueSapphireColor,
              child: ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.04,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Toast.show('This feature is currently unavailable', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                model.logOut();
                Navigator.pushReplacementNamed(context, RoutePaths.Login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
