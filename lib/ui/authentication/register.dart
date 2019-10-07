import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/views/register_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:familytree/ui/main/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegExp emailRegExp = new RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  RegisterViewModel rvm;

  void _onSignUp() async {
    var formState = _formKey.currentState;
    if (formState.validate()) {
      print('Validated');
      formState.save();
      var result = await rvm.registerUser();
      if (rvm.user != null && rvm.user.uid.isNotEmpty) {
        var route = MaterialPageRoute(
          builder: (context) => new HomeScreen(
            userID: result,
          ),
        );
        Navigator.pushReplacement(context, route);
      } else {
        Toast.show(
          result,
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BaseWidget<RegisterViewModel>(
      model: RegisterViewModel(
        firebaseAuthProvider: new FirebaseAuthProvider(),
      ),
      builder: (context, model, child) {
        // registerUser = model.registerUser;
        rvm = model;
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Colors.green,
            ),
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Daftar Akaun',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            height: screenSize.height * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Sila masukkan nama anda';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => model.setName(value),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'Nama',
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.green,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Sila masukkan emel anda';
                                    } else if (!emailRegExp.hasMatch(value)) {
                                      return 'Emel tidak sah. Sila masukkan email yang betul';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => model.setEmail(value),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'Emel',
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.green,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Sila masukkan kata laluan anda';
                                    } else {
                                      model.setPassword(value);
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => model.setPassword(value),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'Kata Laluan',
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.green,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Sila masukkan kata laluan anda';
                                    } else if (value != model.password) {
                                      return 'Kata laluan tidak sama';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'Masuk Semula Kata Laluan',
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.green,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: RadioListTile(
                                        groupValue: model.genderIndex,
                                        title: Text('Lelaki'),
                                        value: 0,
                                        onChanged: (value) =>
                                            model.setGender(value),
                                      ),
                                    ),
                                    Flexible(
                                      child: RadioListTile(
                                        groupValue: model.genderIndex,
                                        title: Text('Wanita'),
                                        value: 1,
                                        onChanged: (value) =>
                                            model.setGender(value),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: RaisedButton(
                            color: Colors.green,
                            onPressed: _onSignUp,
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
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
                      ],
                    ),
                  ),
                ),
              ),
              model.busy ? LoadingOverlay() : Container(),
            ],
          ),
        );
      },
    );
  }
}
