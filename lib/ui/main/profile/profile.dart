import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/viewmodels/views/profile_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      onModelReady: (model) => model.getUser(),
      builder: (context, model, child) => Stack(
        children: <Widget>[
          Container(
            height: screenSize.height * 0.2,
            color: ColorPalette.oceanGreenColor,
          ),
          Container(
            width: screenSize.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.microsoft.com/en-us/research/wp-content/uploads/2017/09/avatar_user_36443_1506533427.jpg'),
                    radius: screenSize.height * 0.07,
                  ),
                ),
                model.user != null
                    ? Container(
                        height: screenSize.height * 0.5,
                        width: screenSize.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 25.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                model.user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Ampang, Selangor',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
                                ),
                              ),
                              Row(
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
                              Divider(
                                color: ColorPalette.keppelColor,
                                thickness: 0.8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Tempat Lahir',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Container(
                                    width: screenSize.width * 0.26,
                                  ),
                                  Text(
                                    'Ipoh, Perak',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Alamat Sekarang',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                      width: screenSize.width * 0.2,
                                    ),
                                    Container(
                                      width: screenSize.width * 0.35,
                                      child: Text(
                                        'No. 18, Jalan Melawati 5/18, Taman Melawati Utama, 6800 Ampang, Selangor Darul Ehsan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Divider(
                  color: ColorPalette.keppelColor,
                  thickness: 0.8,
                ),
                FlatButton(
                  onPressed: model.logOut,
                  child: Text(
                    'Log Keluar',
                    style: TextStyle(
                      color: ColorPalette.blueSapphireColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
