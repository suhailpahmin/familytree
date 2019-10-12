import 'package:intl/intl.dart';

class Pictory {
  String caption;
  String createdOn;
  String postedBy;
  String familyID;

  Pictory({this.caption, this.createdOn, this.postedBy, this.familyID});

  factory Pictory.fromJson(Map<String, dynamic> json) {
    var formatter = new DateFormat('MMM d');
    return new Pictory(
        caption: json['caption'],
        createdOn: formatter.format(json['createdOn'].toDate()),
        familyID: json['familyID'],
        postedBy: json['postedBy'],
      );
  }
}
