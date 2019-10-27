import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/views/family_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:familytree/ui/main/family/family-ui/new_family_dialog.dart';
import 'package:familytree/ui/main/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class FamilyScreen extends StatefulWidget {
  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    Future _openNewFamilyDialog(
        Function(FamilyData newMember) addFamilyMember) async {
      var route = MaterialPageRoute<FamilyData>(
          builder: (BuildContext context) => new NewFamilyDialog(),
          fullscreenDialog: true);
      FamilyData data = await Navigator.of(context).push(route);
      if (data != null) {
        addFamilyMember(data);
      }
    }

    void viewProfile(String userID) {
      var route = MaterialPageRoute(
          builder: (BuildContext context) => new ProfileScreen(
                userID: userID,
              ));
      Navigator.push(context, route);
    }

    void displayMessage(String message) {
      Toast.show(message, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black);
    }

    return BaseWidget<FamilyViewModel>(
      model: FamilyViewModel(
        fireAuth: FirebaseAuth.instance,
        firestore: Firestore.instance,
      ),
      onModelReady: (model) => model.getFamily(),
      builder: (context, model, child) => Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 25.0,
            ),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Ahli Keluarga',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Ibu Bapa',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    model.familyResult != null &&
                            model.familyResult.father != null
                        ? ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            isThreeLine: true,
                            title: Text(
                              model.familyResult.father.name,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                model.familyResult.father.birthDate != null
                                    ? Text(
                                        DateFormat('dd MMMM yyyy').format(model
                                            .familyResult.father.birthDate),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  model.familyResult.father.relation,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (model.familyResult.father.id != null) {
                                if (model.familyResult.father.relation !=
                                    'Anda') {
                                  viewProfile(model.familyResult.father.id);
                                } else {
                                  viewProfile(null);
                                }
                              } else {
                                displayMessage('Tiada akaun dijumpai');
                              }
                            },
                          )
                        : Container(),
                    model.familyResult != null &&
                            model.familyResult.mother != null
                        ? ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            isThreeLine: true,
                            title: Text(
                              model.familyResult.mother.name,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                model.familyResult.mother.birthDate != null
                                    ? Text(
                                        DateFormat('dd MMMM yyyy').format(model
                                            .familyResult.mother.birthDate),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  model.familyResult.mother.relation,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (model.familyResult.mother.id != null) {
                                if (model.familyResult.mother.relation !=
                                    'Anda') {
                                  viewProfile(model.familyResult.mother.id);
                                } else {
                                  viewProfile(null);
                                }
                              } else {
                                displayMessage('Tiada akaun dijumpai');
                              }
                            },
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Adik Beradik',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    model.familyResult != null &&
                            model.familyResult.siblings.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.familyResult.siblings.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              isThreeLine: true,
                              title: Text(
                                model.familyResult.siblings[index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  model.familyResult.siblings[index]
                                              .birthDate !=
                                          null
                                      ? Text(
                                          DateFormat('dd MMMM yyyy').format(
                                              model.familyResult.siblings[index]
                                                  .birthDate),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container(),
                                  // Text(model
                                  //     .familyResult.siblings[index].relation),
                                ],
                              ),
                              onTap: () {
                                if (model.familyResult.siblings[index].id !=
                                    null) {
                                  if (model.familyResult.siblings[index]
                                          .relation !=
                                      'Anda') {
                                    viewProfile(
                                        model.familyResult.siblings[index].id);
                                  } else {
                                    viewProfile(null);
                                  }
                                } else {
                                  displayMessage('Tiada akaun dijumpai');
                                }
                              },
                            ),
                          )
                        : Container(
                            child: Text(
                              'Tiada data adik beradik',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.78,
            right: screenSize.width * 0.1,
            child: FloatingActionButton(
              onPressed: () => _openNewFamilyDialog(model.addFamilyMember),
              child: Icon(Icons.add),
              backgroundColor: ColorPalette.keppelColor,
              mini: true,
            ),
          ),
          model.busy ? LoadingOverlay() : Container(),
        ],
      ),
    );
  }
}
