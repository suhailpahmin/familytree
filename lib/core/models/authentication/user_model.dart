import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

User userFromJson(Map<String, dynamic> json) => User.fromJson(json);

class User {
  final String email;
  final String password;
  final String name;
  final String gender;
  final String phoneNumber;
  final DateTime birthDate;
  String id;
  String birthPlace;
  String currentAddress;
  String currentState;
  String secondNumber;
  String thirdNumber;

  User({
    this.email,
    this.password,
    this.name,
    this.gender,
    this.phoneNumber,
    this.birthDate,
    this.id,
    this.birthPlace,
    this.currentAddress,
    this.currentState,
    this.secondNumber,
    this.thirdNumber
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        email: json['email'],
        name: json['name'],
        gender: json['gender'] != null ? json['gender'] : null,
        phoneNumber: json['phone'],
        birthDate: json['birthDate'] != null ? json['birthDate'] is Timestamp ? json['birthDate'].toDate() : DateTime.parse(json['birthDate']) : null,
        id: json['id'] != null ? json['id'] : null,
        birthPlace: json['birthPlace'] != null ? json['birthPlace'] : null,
        currentAddress:
            json['currentAddress'] != null ? json['currentAddress'] : null,
        currentState:
            json['currentState'] != null ? json['currentState'] : null,
        secondNumber: json['secondNumber'] != null ? json['secondNumber'] : null,
        thirdNumber: json['thirdNumber'] != null ? json['thirdNumber'] : null,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'gender': gender != null ? gender : null,
        'phone': phoneNumber,
        'birthDate': birthDate != null ? DateFormat('yyyyMMdd').format(birthDate) : null,
        'id': id != null ? id : null,
        'birthPlace': birthPlace != null ? birthPlace : null,
        'currentAddress': currentAddress != null ? currentAddress : null,
        'currentState': currentState != null ? currentState : null,
        'secondNumber': secondNumber != null ? secondNumber : null,
        'thirdNumber': thirdNumber != null ? thirdNumber : null,
      };
}
