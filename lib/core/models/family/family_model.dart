import 'package:familytree/core/models/family/familydata_model.dart';

class FamilyModel {
  FamilyData mother;
  FamilyData father;
  List<FamilyData> siblings;

  FamilyModel({this.mother, this.father, this.siblings});
}
