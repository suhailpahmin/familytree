import 'package:intl/intl.dart';

Pictory pictoryFromjson(Map<String, dynamic> json) => Pictory.fromJson(json);
List<Map<String, dynamic>> pictoriesToJson(List<Pictory> pictory) =>
    List<Map<String, dynamic>>.from(pictory.map((x) => x.toJson()));

List<Pictory> pictoriesFromJson(List<dynamic> jsonData) =>
    List<Pictory>.from(jsonData.map((x) {
      var xJson = new Map<String, dynamic>.from(x);
      return Pictory.fromJson(xJson);
    }));

class Pictory {
  String image;
  String title;
  String story;
  DateTime date;
  String id;

  Pictory({
    this.image,
    this.title,
    this.story,
    this.date,
    this.id,
  });

  factory Pictory.fromJson(Map<String, dynamic> json) => new Pictory(
        image: json['image'],
        title: json['title'],
        story: json['story'],
        date: DateTime.parse(json['date']),
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'title': title,
        'story': story,
        'date': DateFormat('yyyyMMddTHHmmss').format(date),
        'id': id,
      };
}
