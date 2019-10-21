import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/views/family_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:familytree/ui/main/family/family-ui/new_family_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({Key key}) : super(key: key);

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    Future _openNewFamilyDialog(Function(FamilyData newMember) addFamilyMember) async {
      var route = MaterialPageRoute<FamilyData>(builder: (BuildContext context) => new NewFamilyDialog(), fullscreenDialog: true);
      FamilyData data = await Navigator.of(context).push(route);
      if (data != null) {
        addFamilyMember(data);
      }
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
                    Text(
                      'Ahli Keluarga',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                    Text(
                      'Ibu Bapa',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                    model.familyResult != null &&
                            model.familyResult.father != null
                        ? ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            isThreeLine: true,
                            title: Text(model.familyResult.father.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(DateFormat('dd MMMM yyyy').format(
                                    model.familyResult.father.birthDate)),
                                Text(model.familyResult.father.relation),
                              ],
                            ),
                          )
                        : Container(),
                    model.familyResult != null &&
                            model.familyResult.mother != null
                        ? ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            isThreeLine: true,
                            title: Text(model.familyResult.mother.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(DateFormat('dd MMMM yyyy').format(
                                    model.familyResult.mother.birthDate)),
                                Text(model.familyResult.mother.relation),
                              ],
                            ),
                          )
                        : Container(),
                    Text(
                      'Adik Beradik',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
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
                              title:
                                  Text(model.familyResult.siblings[index].name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(DateFormat('dd MMMM yyyy').format(model
                                      .familyResult.siblings[index].birthDate)),
                                  Text(model
                                      .familyResult.siblings[index].relation),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            child: Text('Tiada data adik beradik'),
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
              onPressed: () =>  _openNewFamilyDialog(model.addFamilyMember),
              child: Icon(Icons.add),
              backgroundColor: ColorPalette.oceanGreenColor,
              mini: true,
            ),
          ),
          model.busy ? LoadingOverlay() : Container(),
        ],
      ),
    );
  }
}
