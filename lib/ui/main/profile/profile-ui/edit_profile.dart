import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/viewmodels/widget/edit_profile_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class EditProfileDialog extends StatefulWidget {
  final Function(User user) updateUser;
  final User user;
  const EditProfileDialog({this.updateUser, this.user});

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  User updateData;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: new AppBar(
        title: const Text('Kemaskini Profil'),
        centerTitle: true,
      ),
      body: BaseWidget<EditProfileViewModel>(
        model: EditProfileViewModel(firestore: Firestore.instance),
        builder: (context, model, child) => Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 120.0,
                      top: 25.0,
                      bottom: 25.0,
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.microsoft.com/en-us/research/wp-content/uploads/2017/09/avatar_user_36443_1506533427.jpg'),
                      radius: screenSize.height * 0.07,
                    ),
                  ),
                  Divider(
                    thickness: 2.0,
                    color: ColorPalette.oceanGreenColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: TextFormField(
                      onSaved: model.setBirthPlace,
                      initialValue: widget.user.birthPlace,
                      decoration: InputDecoration(
                        hintText: 'Tempat Lahir',
                        labelText: 'Tempat Lahir',
                        contentPadding: EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: ColorPalette.keppelColor,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: ColorPalette.keppelColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: TextFormField(
                      onSaved: model.setCurrentAddress,
                      initialValue: widget.user.currentAddress,
                      decoration: InputDecoration(
                        hintText: 'Alamat Sekarang',
                        labelText: 'Alamat',
                        contentPadding: EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: ColorPalette.keppelColor,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: ColorPalette.keppelColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: TextFormField(
                      onSaved: model.setCurrentState,
                      initialValue: widget.user.currentState,
                      decoration: InputDecoration(
                        hintText: 'Negeri Sekarang',
                        labelText: 'Negeri',
                        contentPadding: EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: ColorPalette.keppelColor,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: ColorPalette.keppelColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2.0,
                    color: ColorPalette.oceanGreenColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Toast.show('This feature is coming soon', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    },
                    child: Text(
                      'Change Picture',
                      style: TextStyle(
                        color: ColorPalette.keppelColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2.0,
                    color: ColorPalette.oceanGreenColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Center(
                      child: Container(
                        width: screenSize.width * 0.5,
                        height: screenSize.height * 0.05,
                        child: RaisedButton(
                          color: ColorPalette.blueSapphireColor,
                          onPressed: () async {
                            _formKey.currentState.save();
                            await model.updateProfile(widget.user.id);
                            widget.user.birthPlace = model.birthPlace;
                            widget.user.currentAddress = model.currentAddress;
                            widget.user.currentState = model.currentState;
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Simpan',
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
        ),
      ),
    );
  }
}
