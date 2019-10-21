// List<String> familiesToJson(List<FamilyData> data) => List<String>.from(data.map((x) => x.toJson()));
List<Map<String, dynamic>> familiesToJson(List<FamilyData> data) =>
    List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

List<FamilyData> familiesFromJson(List<dynamic> jsonData) =>
    List<FamilyData>.from(jsonData.map((x) {
      var xJson = new Map<String,dynamic>.from(x);
      return FamilyData.fromJson(xJson);
    }));

FamilyData familyFromJson(Map<String, dynamic> json) => FamilyData.fromJson(json);

class FamilyData {
  String name;
  String phoneNumber;
  DateTime birthDate;
  String relation;
  String gender;

  FamilyData(
      {this.name,
      this.phoneNumber,
      this.birthDate,
      this.relation,
      this.gender});

  factory FamilyData.fromJson(Map<String, dynamic> json) => new FamilyData(
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        birthDate: DateTime.parse(json['birthDate']),
        relation: json['relation'],
        gender: json['gender'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'birthDate': birthDate.toIso8601String(),
        'relation': relation,
        'gender': gender
      };
}
