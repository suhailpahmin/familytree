import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/pictory/pictory_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class EditPictoryViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseStorage _fireStorage;
  File _pictoryImage;
  File get pictoryImage => _pictoryImage;
  String _image;
  String _title;
  String get title => _title;
  String _story;
  String get story => _story;
  DateTime _date = DateTime.now();
  DateTime get date => _date;
  String _userID;
  Pictory _pictory;
  Pictory get pictory => _pictory;

  EditPictoryViewModel(
      {Firestore firestore, FirebaseStorage firebaseStorage, String userID}) {
    _firestore = firestore;
    _fireStorage = firebaseStorage;
    _userID = userID;
  }

  Future<Pictory> updatePictory(Pictory pictory) async {
    setBusy(true);
    try {
      var searchPictory = await _firestore
          .collection('pictories')
          .where('pictories', arrayContains: {
            'date': DateFormat('yyyyMMddTHHmmss').format(pictory.date),
            'image': pictory.image,
            'story': pictory.story,
            'title': pictory.title,
            'id': pictory.id,
          })
          .limit(1)
          .getDocuments();
      if (searchPictory.documents != null &&
          searchPictory.documents.length > 0) {
        var pictoryData = new List<dynamic>.from(
            searchPictory.documents.first.data['pictories']);
        List<Pictory> pictories = pictoriesFromJson(pictoryData);
        if (_pictoryImage != null) {
          final StorageReference storageReference = _fireStorage
              .ref()
              .child('pictories/$_userID/${basename(_pictoryImage.path)}');
          StorageUploadTask uploadTask =
              storageReference.putFile(_pictoryImage);
          final StorageTaskSnapshot downloadURL = (await uploadTask.onComplete);
          _image = (await downloadURL.ref.getDownloadURL());
        }

        var newPictory = new Pictory(
          date: _date != null ? _date : pictory.date,
          title: _title != null ? _title : pictory.title,
          story: _story != null ? _story : pictory.story,
          image: _image != null ? _image : pictory.image,
          id: pictory.id,
        );
        pictories.asMap().forEach((index, s) {
          if (s.id == pictory.id) {
            pictories[index] = newPictory;
          }
        });
        await _firestore
            .collection('pictories')
            .document(searchPictory.documents.first.documentID)
            .updateData({'pictories': pictoriesToJson(pictories)});
        setBusy(false);
        return newPictory;
      } else {
        setBusy(false);
        return pictory;
      }
    } catch (err) {
      throw err;
    }
  }

  void updateImage(File pictoryImage) {
    _pictoryImage = pictoryImage;
    notifyListeners();
  }

  void updateTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void updateDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  void updateStory(String story) {
    _story = story;
    notifyListeners();
  }
}
