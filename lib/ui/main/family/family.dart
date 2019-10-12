import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/viewmodels/views/family_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({Key key}) : super(key: key);

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  TextEditingController _familyIDController = TextEditingController();
  FamilyViewModel fvm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _familyIDController.dispose();
    super.dispose();
  }

  void searchFamily() async {
    var family = await fvm.findFamily(_familyIDController.text);
    if (family != null) {
      Navigator.pop(context);
    }
  }

  void _findFamily() {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 125,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  // color: ColorPalette.teaGreenColor,
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _familyIDController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Masukkan Family ID',
                    hintStyle:
                        TextStyle(color: ColorPalette.blueSapphireColor)),
              ),
            ),
            RaisedButton(
              color: ColorPalette.oceanGreenColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.00),
              ),
              onPressed: searchFamily,
              child: Text(
                'Cari',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<FamilyViewModel>(
      model: FamilyViewModel(
        fireAuth: FirebaseAuth.instance,
        firestore: Firestore.instance,
      ),
      onModelReady: (model) => model.getFamily(),
      builder: (context, model, child) {
        fvm = model;
        return Stack(
          children: <Widget>[
            model.familyResult != null
                ? Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 120.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Family Dijumpai',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.blueSapphireColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Family ID : ',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorPalette.blueSapphireColor,
                                ),
                              ),
                              Text(
                                model.familyID,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorPalette.blueSapphireColor,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: model.familyMembers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                title: Text(
                                  model.familyMembers[index],
                                ),
                              );
                              },
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  color: ColorPalette.blueSapphireColor,
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(
                                      color: ColorPalette.teaGreenColor,
                                    ),
                                  ),
                                  onPressed: () => model.cancelSearch(),
                                ),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  color: ColorPalette.blueSapphireColor,
                                  child: Text(
                                    'Masuk',
                                    style: TextStyle(
                                      color: ColorPalette.teaGreenColor,
                                    ),
                                  ),
                                  onPressed: model.joinFamily,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
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
                            'Family',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: model.familyID != null
                                ? Text('Family ID : ${model.familyID}')
                                : Container(),
                          ),
                          model.familyMembers != null &&
                                  model.familyMembers.length > 0
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: model.familyMembers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            ListTile(
                                      title: Text(
                                        model.familyMembers[index],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          model.familyMembers != null &&
                                  model.familyMembers.length == 0
                              ? Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 25.0),
                                            child: Text(
                                              'Anda tidak ada di dalam mana-mana family',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: ColorPalette.keppelColor,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  color: ColorPalette
                                                      .blueSapphireColor,
                                                  child: Text(
                                                    'Daftar Family',
                                                    style: TextStyle(
                                                      color: ColorPalette
                                                          .teaGreenColor,
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      model.registerFamily(),
                                                ),
                                                RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  color: ColorPalette
                                                      .blueSapphireColor,
                                                  child: Text(
                                                    'Cari Family',
                                                    style: TextStyle(
                                                      color: ColorPalette
                                                          .teaGreenColor,
                                                    ),
                                                  ),
                                                  onPressed: _findFamily,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
            model.busy ? LoadingOverlay() : Container(),
          ],
        );
      },
    );
  }
}
