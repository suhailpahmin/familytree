// List<String> familiesToJson(List<FamilyData> data) => List<String>.from(data.map((x) => x.toJson()));
List<Map<String, dynamic>> familiesToJson(List<FamilyData> data) =>
    List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

List<FamilyData> familiesFromJson(List<dynamic> jsonData) =>
    List<FamilyData>.from(jsonData.map((x) {
      var xJson = new Map<String, dynamic>.from(x);
      return FamilyData.fromJson(xJson);
    }));

FamilyData familyFromJson(Map<String, dynamic> json) =>
    FamilyData.fromJson(json);

class FamilyData {
  String name;
  String phoneNumber;
  String secondNumber;
  String thirdNumber;
  DateTime birthDate;
  String relation;
  String gender;
  String id;

  FamilyData({
    this.name,
    this.phoneNumber,
    this.birthDate,
    this.relation,
    this.gender,
    this.id,
    this.secondNumber,
    this.thirdNumber,
  });

  factory FamilyData.fromJson(Map<String, dynamic> json) => new FamilyData(
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        birthDate:
            json['birthDate'] != null ? json['birthDate'].toDate() : null,
        gender: json['gender'] != null ? json['gender'] : null,
        id: json['id'] != null ? json['id'] : null,
        secondNumber:
            json['secondNumber'] != null ? json['secondNumber'] : null,
        thirdNumber: json['thirdNumber'] != null ? json['thirdNumber'] : null,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'birthDate': birthDate != null ? birthDate : null,
        'gender': gender != null ? gender : null,
        'id': id != null ? id : null,
        'secondNumber': secondNumber != null ? secondNumber : null,
        'thirdNumber': thirdNumber != null ? thirdNumber : null,
      };
}
