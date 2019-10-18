import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/views/familyregister_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterFamilyScreen extends StatefulWidget {
  final Function(FamilyData data) setFamily;
  final String relation;

  RegisterFamilyScreen({this.setFamily, this.relation});

  _RegisterFamilyScreenState createState() => _RegisterFamilyScreenState();
}

class _RegisterFamilyScreenState extends State<RegisterFamilyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _dateFormat = 'dd MM yyyy';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BaseWidget<FamilyRegisterViewModel>(
      model: FamilyRegisterViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: ColorPalette.oceanGreenColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Daftar Ahli Keluarga',
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
                              padding:
                                  const EdgeInsets.fromLTRB(10.0, 15.0, 25.0, 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Hubungan'),
                                  Text(widget.relation),
                                ],
                              ),
                            ),
                          ),
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
                          InternationalPhoneNumberInput.withCustomDecoration(
                            onInputChanged: (value) =>
                                model.setPhoneNumber(value),
                            initialCountry2LetterCode: 'MY',
                            inputDecoration: InputDecoration(
                              hintText: 'Telefon',
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
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
                                    onPressed: () => DatePicker.showDatePicker(
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
                                      onConfirm: (dateTime, List<int> index) =>
                                          model.setBirthDate(dateTime),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          widget.relation == 'Adik Beradik' ? Row(
                            children: <Widget>[
                              Flexible(
                                child: RadioListTile(
                                  activeColor: ColorPalette.keppelColor,
                                  groupValue: model.genderIndex,
                                  title: Text('Lelaki'),
                                  value: 0,
                                  onChanged: (value) => model.setGender(value),
                                ),
                              ),
                              Flexible(
                                child: RadioListTile(
                                  groupValue: model.genderIndex,
                                  title: Text('Wanita'),
                                  value: 1,
                                  onChanged: (value) => model.setGender(value),
                                ),
                              ),
                            ],
                          ) : Container(),
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
                        onPressed: () {
                          var formState = _formKey.currentState;
                          if (formState.validate()) {
                            print('Validated');
                            formState.save();
                            widget.setFamily(new FamilyData(name: model.name, phoneNumber: model.phoneNumber, birthDate: model.birthDate, relation: widget.relation, gender: model.gender));
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Tambah',
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
      ),
    );
  }
}
