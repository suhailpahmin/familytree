import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/views/family_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:familytree/ui/main/family/family-ui/new_family_dialog.dart';
import 'package:familytree/ui/main/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
        fullscreenDialog: true,
      );
      FamilyData data = await Navigator.of(context).push(route);
      if (data != null) {
        addFamilyMember(data);
      }
    }

    void viewProfile(String userID) {
      var route = MaterialPageRoute(
          builder: (BuildContext context) => new ProfileScreen(userID: userID));
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
        smsProvider: Provider.of(context),
        user: Provider.of<User>(context)
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
                    Text(
                      'Jumlah ahli keluarga yang berdaftar sekarang : ${model.totalRegisteredMember} orang',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
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
                    model.familyResult != null &&
                            model.familyResult.father != null
                        ? ListTile(
                            leading: Container(
                              height: screenSize.height,
                              child: CircleAvatar(
                                radius: screenSize.width * 0.1,
                                child: model.familyResult.father.image != null
                                    ? ClipOval(
                                        child: Image.network(
                                          model.familyResult.father.image,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(Icons.person),
                              ),
                            ),
                            trailing: Container(
                              height: screenSize.height,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                            isThreeLine: true,
                            title: Text(
                              model.familyResult.father.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
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
                    Divider(
                      color: Colors.white,
                    ),
                    model.familyResult != null &&
                            model.familyResult.mother != null
                        ? ListTile(
                            leading: Container(
                              height: screenSize.height,
                              child: CircleAvatar(
                                radius: screenSize.width * 0.1,
                                child: model.familyResult.mother.image != null
                                    ? ClipOval(
                                        child: Image.network(
                                          model.familyResult.mother.image,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(Icons.person),
                              ),
                            ),
                            trailing: Container(
                              height: screenSize.height,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                            isThreeLine: true,
                            title: Text(
                              model.familyResult.mother.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
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
                    Divider(
                      color: Colors.white,
                    ),
                    model.familyResult != null &&
                            model.familyResult.siblings.length > 0
                        ? ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.white,
                            ),
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model.familyResult.siblings.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: Container(
                                height: screenSize.height,
                                child: CircleAvatar(
                                  radius: screenSize.width * 0.1,
                                  child: model.familyResult.siblings[index]
                                              .image !=
                                          null
                                      ? ClipOval(
                                          child: Image.network(
                                            model.familyResult.siblings[index]
                                                .image,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(Icons.person),
                                ),
                              ),
                              trailing: Container(
                                height: screenSize.height,
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                              isThreeLine: true,
                              title: Text(
                                model.familyResult.siblings[index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
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
                                  Text(
                                    model.familyResult.siblings[index]
                                                .relation !=
                                            null
                                        ? model.familyResult.siblings[index]
                                            .relation
                                        : 'Adik Beradik (Baru)',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
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
                    Divider(
                      color: Colors.white,
                    ),
                    model.familyResult != null &&
                            model.familyResult.spouse != null
                        ? ListTile(
                            leading: Container(
                              height: screenSize.height,
                              child: CircleAvatar(
                                radius: screenSize.width * 0.1,
                                child: model.familyResult.spouse.image != null
                                    ? ClipOval(
                                        child: Image.network(
                                          model.familyResult.spouse.image,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(Icons.person),
                              ),
                            ),
                            trailing: Container(
                              height: screenSize.height,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                            isThreeLine: true,
                            title: Text(
                              model.familyResult.spouse.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                model.familyResult.spouse.birthDate != null
                                    ? Text(
                                        DateFormat('dd MMMM yyyy').format(model
                                            .familyResult.spouse.birthDate),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  model.familyResult.spouse.relation,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (model.familyResult.spouse.id != null) {
                                if (model.familyResult.spouse.relation !=
                                    'Anda') {
                                  viewProfile(model.familyResult.spouse.id);
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
                            model.familyResult.children.length > 0
                        ? ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.white,
                            ),
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model.familyResult.children.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: Container(
                                height: screenSize.height,
                                child: CircleAvatar(
                                  radius: screenSize.width * 0.1,
                                  child: model.familyResult.children[index]
                                              .image !=
                                          null
                                      ? ClipOval(
                                          child: Image.network(
                                            model.familyResult.children[index]
                                                .image,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(Icons.person),
                                ),
                              ),
                              trailing: Container(
                                height: screenSize.height,
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                              isThreeLine: true,
                              title: Text(
                                model.familyResult.children[index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  model.familyResult.children[index]
                                              .birthDate !=
                                          null
                                      ? Text(
                                          DateFormat('dd MMMM yyyy').format(
                                              model.familyResult.children[index]
                                                  .birthDate),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    model.familyResult.children[index]
                                                .relation !=
                                            null
                                        ? model.familyResult.children[index]
                                            .relation
                                        : 'Adik Beradik (Baru)',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (model.familyResult.children[index].id !=
                                    null) {
                                  if (model.familyResult.children[index]
                                          .relation !=
                                      'Anda') {
                                    viewProfile(
                                        model.familyResult.children[index].id);
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
            top: screenSize.height * 0.7,
            right: screenSize.width * 0.1,
            child: FloatingActionButton(
              onPressed: () => _openNewFamilyDialog(model.addFamilyMember),
              child: Icon(Icons.add),
              backgroundColor: ColorPalette.keppelColor,
            ),
          ),
          model.busy ? LoadingOverlay() : Container(),
        ],
      ),
    );
  }
}
