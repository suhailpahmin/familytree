import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/viewmodels/views/register_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:familytree/ui/helper/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegExp emailRegExp = new RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  RegisterViewModel rvm;
  String _dateFormat = 'dd MM yyyy';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  void _onSignUp() async {
    var formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      var userResult = await rvm.registerUser();
      if (userResult.isNotEmpty) {
        if (userResult == 'Has Family') {
          Navigator.pushReplacementNamed(context, RoutePaths.Home);
        } else if (userResult.contains('error')) {
          Toast.show(
            userResult,
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        } else {
          Toast.show(userResult, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
          Navigator.pushReplacementNamed(context, RoutePaths.FirstTime,
              arguments: userResult);
        }
      }
    }
  }

  void _showDatePicker(Function(DateTime value) setBirthDate) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(
          'Terima',
          style: TextStyle(
            color: ColorPalette.oceanGreenColor,
          ),
        ),
        cancel: Text(
          'Batal',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _dateFormat,
      locale: _locale,
      onConfirm: (dateTime, List<int> index) => setBirthDate(dateTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BaseWidget<RegisterViewModel>(
      model: RegisterViewModel(
        firebaseAuthProvider: Provider.of(context),
      ),
      builder: (context, model, child) {
        rvm = model;
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: ColorPalette.oceanGreenColor,
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
                            height: screenSize.height,
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
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'Nama',
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.user,
                                      color: ColorPalette.keppelColor,
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
                                        color: ColorPalette.oceanGreenColor,
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
                                InternationalPhoneNumberInput
                                    .withCustomDecoration(
                                  onInputChanged: model.setPhoneNumber,
                                  onInputValidated: model.setValidNumber,
                                  initialCountry2LetterCode: 'MY',
                                  inputDecoration: InputDecoration(
                                    hintText: 'Telefon Utama',
                                    errorText: model.validNumber
                                        ? null
                                        : 'Nombor tidak sah',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                                InternationalPhoneNumberInput
                                    .withCustomDecoration(
                                  onInputChanged: model.setSecondNumber,
                                  initialCountry2LetterCode: 'MY',
                                  inputDecoration: InputDecoration(
                                    hintText: 'Telefon Kedua',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                                InternationalPhoneNumberInput
                                    .withCustomDecoration(
                                  onInputChanged: model.setThirdNumber,
                                  initialCountry2LetterCode: 'MY',
                                  inputDecoration: InputDecoration(
                                    hintText: 'Telefon Ketiga',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[350],
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Tarikh Lahir : ',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              Text(
                                                '${model.birthDate.day.toString().padLeft(2, '0')} ${model.birthDate.month.toString().padLeft(2, '0')} ${model.birthDate.year}',
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.arrow_drop_down),
                                          onPressed: () => _showDatePicker(
                                              model.setBirthDate),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: RadioListTile(
                                        activeColor: ColorPalette.keppelColor,
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
                                      color: ColorPalette.keppelColor,
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
                                        color: ColorPalette.oceanGreenColor,
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
                                      color: ColorPalette.keppelColor,
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
                                        color: ColorPalette.oceanGreenColor,
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
                                      color: ColorPalette.keppelColor,
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
                                        color: ColorPalette.oceanGreenColor,
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
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: screenSize.width * 0.5,
                            height: screenSize.height * 0.05,
                            child: RaisedButton(
                              color: ColorPalette.blueSapphireColor,
                              onPressed: _onSignUp,
                              child: Text(
                                'Daftar',
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
