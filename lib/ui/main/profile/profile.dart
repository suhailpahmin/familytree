import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/viewmodels/views/profile_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/main/profile/profile-ui/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;

  ProfileScreen({this.userID});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BaseWidget<ProfileViewModel>(
      model: ProfileViewModel(
          firestore: Firestore.instance,
          firebaseAuth: FirebaseAuth.instance,
          user: Provider.of<User>(context)),
      onModelReady: (model) => model.getUser(widget.userID),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: screenSize.height * 0.2,
              color: ColorPalette.oceanGreenColor,
            ),
            Container(
              width: screenSize.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 80.0,
                        left: 150.0,
                      ),
                      child: CircleAvatar(
                        backgroundImage: model.user.image == null
                            ? NetworkImage(
                                'https://www.microsoft.com/en-us/research/wp-content/uploads/2017/09/avatar_user_36443_1506533427.jpg')
                            : null,
                        child: model.user.image != null
                            ? ClipOval(
                                child: Image.network(
                                  model.user.image,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                        radius: screenSize.height * 0.07,
                      ),
                    ),
                    model.user != null
                        ? Container(
                            width: screenSize.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    model.user.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: model.user.currentState != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: ColorPalette
                                                      .blueSapphireColor,
                                                ),
                                                Container(
                                                  width:
                                                      screenSize.width * 0.02,
                                                ),
                                                Text(
                                                  model.user.currentState,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Tarikh Lahir',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Container(
                                          width: screenSize.width * 0.26,
                                        ),
                                        Text(
                                          DateFormat('dd MMMM yyyy')
                                              .format(model.user.birthDate),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: ColorPalette.keppelColor,
                                    thickness: 0.8,
                                  ),
                                  model.user.birthPlace != null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Tempat Lahir',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Container(
                                                width: screenSize.width * 0.24,
                                              ),
                                              Text(
                                                model.user.birthPlace,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  model.user.currentAddress != null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Alamat Sekarang',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Container(
                                                width: screenSize.width * 0.19,
                                              ),
                                              Container(
                                                width: screenSize.width * 0.35,
                                                child: Text(
                                                  model.user.currentAddress,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Telefon Utama',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Container(
                                          width: screenSize.width * 0.22,
                                        ),
                                        Container(
                                          width: screenSize.width * 0.35,
                                          child: Text(
                                            model.user.phoneNumber != null
                                                ? model.user.phoneNumber
                                                : 'Tiada Number',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  model.user.secondNumber != null &&
                                          model.user.secondNumber.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Telefon Kedua',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Container(
                                                width: screenSize.width * 0.24,
                                              ),
                                              Container(
                                                width: screenSize.width * 0.35,
                                                child: Text(
                                                  model.user.secondNumber,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  model.user.thirdNumber != null &&
                                          model.user.thirdNumber.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Telefon Ketiga',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Container(
                                                width: screenSize.width * 0.24,
                                              ),
                                              Container(
                                                width: screenSize.width * 0.35,
                                                child: Text(
                                                  model.user.thirdNumber,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    widget.userID == null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Divider(
                              color: ColorPalette.keppelColor,
                              thickness: 0.8,
                            ),
                          )
                        : Container(),
                    widget.userID == null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: FlatButton(
                              onPressed: () async => await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditProfileDialog(
                                  updateUser: model.updateUser,
                                  user: model.user,
                                ),
                                fullscreenDialog: true,
                              )),
                              child: Text(
                                'Kemaskini Profil',
                                style: TextStyle(
                                  color: ColorPalette.blueSapphireColor,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    widget.userID == null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Divider(
                              color: ColorPalette.keppelColor,
                              thickness: 0.8,
                            ),
                          )
                        : Container(),
                    widget.userID == null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: FlatButton(
                              onPressed: () {
                                model.logOut();
                                Navigator.pushReplacementNamed(
                                    context, RoutePaths.Login);
                              },
                              child: Text(
                                'Log Keluar',
                                style: TextStyle(
                                  color: ColorPalette.blueSapphireColor,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    widget.userID != null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Divider(
                              color: ColorPalette.keppelColor,
                              thickness: 0.8,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            model.busy
                ? Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
