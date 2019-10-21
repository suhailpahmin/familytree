User userFromJson(Map<String,dynamic> json) => User.fromJson(json);
class User {
  final String email;
  final String password;
  final String name;
  final String gender;
  final String phoneNumber;
  final DateTime birthDate;
  String id;

  User({this.email, this.password, this.name, this.gender, this.phoneNumber, this.birthDate});

  factory User.fromJson(Map<String,dynamic> json) => new User(
    email: json['email'],
    name: json['name'],
    gender: json['gender'],
    phoneNumber: json['phone'],
    birthDate: json['birthdate'].toDate(),
  );
}