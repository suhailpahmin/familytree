import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/viewmodels/views/firsttime_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:familytree/ui/main/registerfamily.dart';
import 'package:flutter/material.dart';

class FirstTimeScreen extends StatefulWidget {
  final String userID;
  FirstTimeScreen({this.userID});

  _FirstTimeScreenState createState() => _FirstTimeScreenState();
}

class _FirstTimeScreenState extends State<FirstTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BaseWidget<FirstTimeViewModel>(
        model: FirstTimeViewModel(firestore: Firestore.instance),
        builder: (context, model, child) => Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: screenSize.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 50.0,
                  horizontal: 25.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Maklumat Keluarga',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Maklumat Ibu Bapa',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: ColorPalette.oceanGreenColor,
                            child: Icon(
                              Icons.person,
                              color: ColorPalette.teaGreenColor,
                            ),
                          ),
                          title: Text('Ibu'),
                          trailing: model.mother != null
                              ? Text(model.mother.name)
                              : FlatButton(
                                  onPressed: () {
                                    var route = MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterFamilyScreen(
                                        setFamily: model.setMother,
                                        relation: 'Ibu',
                                      ),
                                    );
                                    return Navigator.push(context, route);
                                  },
                                  child: Text(
                                    'Isi Maklumat',
                                    style: TextStyle(
                                      color: ColorPalette.keppelColor,
                                    ),
                                  ),
                                ),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: ColorPalette.oceanGreenColor,
                            child: Icon(
                              Icons.person,
                              color: ColorPalette.teaGreenColor,
                            ),
                          ),
                          title: Text('Bapa'),
                          trailing: model.father != null
                              ? Text(model.father.name)
                              : FlatButton(
                                  onPressed: () {
                                    var route = MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterFamilyScreen(
                                        setFamily: model.setFather,
                                        relation: 'Bapa',
                                      ),
                                    );
                                    return Navigator.push(context, route);
                                  },
                                  child: Text(
                                    'Isi Maklumat',
                                    style: TextStyle(
                                      color: ColorPalette.keppelColor,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Maklumat Adik Beradik',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    model.siblings.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.siblings.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: ColorPalette.oceanGreenColor,
                                child: Icon(
                                  Icons.person,
                                  color: ColorPalette.teaGreenColor,
                                ),
                              ),
                              title: Text(model.siblings[index].name),
                              trailing: Text(
                                '${model.siblings[index].birthDate.day.toString().padLeft(2, '0')} ${model.siblings[index].birthDate.month.toString().padLeft(2, '0')} ${model.siblings[index].birthDate.year}',
                              ),
                            ),
                          )
                        : Container(),
                    FlatButton(
                      onPressed: () {
                        var route = MaterialPageRoute(
                          builder: (context) => RegisterFamilyScreen(
                            setFamily: model.setSibling,
                            relation: 'Adik Beradik',
                          ),
                        );
                        return Navigator.push(context, route);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Tambah Adik Beradik',
                            style: TextStyle(
                              color: ColorPalette.keppelColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Center(
                        child: Container(
                          width: screenSize.width * 0.5,
                          height: screenSize.height * 0.05,
                          child: RaisedButton(
                            color: ColorPalette.blueSapphireColor,
                            onPressed: () async {
                              var result = await model.registerFamily(widget.userID);
                              if (result) {
                                return Navigator.pushNamed(
                                    context, RoutePaths.Home);
                              }
                              return null;
                            },
                            child: Text(
                              'Daftar Keluarga',
                              style: TextStyle(
                                color: ColorPalette.teaGreenColor,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            model.busy ? LoadingOverlay() : Container(),
          ],
        ),
      ),
    );
  }
}
