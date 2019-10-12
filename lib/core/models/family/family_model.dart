class FamilyModel {
  List<String> members;
  DateTime createdOn;

  FamilyModel({this.members, this.createdOn});

  factory FamilyModel.fromJson(Map<String, dynamic> json) => new FamilyModel(
        members: List<String>.from(json['members'].map((x) => x)),
        createdOn: json['createdOn'].toDate(),
      );
}
