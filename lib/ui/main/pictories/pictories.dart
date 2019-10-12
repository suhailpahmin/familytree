import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/pictory/pictorydata_model.dart';
import 'package:familytree/core/viewmodels/views/pictories_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class PictoriesScreen extends StatefulWidget {
  @override
  _PictoriesScreenState createState() => _PictoriesScreenState();
}

class _PictoriesScreenState extends State<PictoriesScreen> {
  PictoriesViewModel pvm;
  TextEditingController caption = TextEditingController();

  @override
  void dispose() {
    caption.dispose();
    super.dispose();
  }

  void submitPictory() async {
    await pvm.newPictory(
        new PictoryData(caption: caption.text, createdOn: DateTime.now()));
    caption.clear();
    Toast.show(
      'Pictory telah dihantar!',
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
    Navigator.pop(context);
  }

  void newPictory() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.clear,
                    ),
                  ),
                  Spacer(),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: ColorPalette.oceanGreenColor,
                    onPressed: submitPictory,
                    child: Text(
                      'Hantar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              TextField(
                controller: caption,
                maxLines: 3,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: 'Apa yang sedang berlaku?',
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.image,
                      color: ColorPalette.blueSapphireColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
          padding: EdgeInsets.all(40.0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BaseWidget<PictoriesViewModel>(
      model: PictoriesViewModel(
        firebaseAuth: FirebaseAuth.instance,
        firestore: Firestore.instance,
      ),
      onModelReady: (model) => model.initializeModel(),
      builder: (context, model, child) {
        pvm = model;
        return Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 80.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pictories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                    model.hasFamily != null && model.hasFamily
                        ? Container()
                        : Expanded(
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25.0),
                                      child: Text(
                                        'Masuk di dalam family untuk memulakan pictories',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: ColorPalette.keppelColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            model.hasFamily != null && model.hasFamily
                ? Positioned(
                    top: screenSize.height * 0.83,
                    right: screenSize.width * 0.05,
                    child: FloatingActionButton.extended(
                      onPressed: newPictory,
                      icon: Icon(Icons.edit),
                      label: Text('Tambah'),
                    ),
                  )
                : Container(),
            model.busy ? LoadingOverlay() : Container(),
          ],
        );
      },
    );
  }
}
