import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/pictory/pictory_model.dart';
import 'package:familytree/ui/main/pictories/edit_pictory.dart';
import 'package:flutter/material.dart';

class PictoryDetailScreen extends StatefulWidget {
  final Pictory pictory;

  PictoryDetailScreen({this.pictory});

  @override
  _PictoryDetailScreenState createState() => _PictoryDetailScreenState();
}

class _PictoryDetailScreenState extends State<PictoryDetailScreen> {
  Pictory newData;

  void updatePictory() async {
    var newPictory = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              EditPictoryScreen(pictory: newData != null ? newData : widget.pictory),
          fullscreenDialog: true),
    );
    setState(() {
      newData = newPictory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          newData != null ? newData.title.toUpperCase() : widget.pictory.title.toUpperCase(),
          style: TextStyle(
            fontSize: screenSize.width * 0.04,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => updatePictory(),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              newData != null ? newData.image : widget.pictory.image,
              fit: BoxFit.cover,
              height: screenSize.height * 0.3,
            ),
            Divider(
              color: ColorPalette.keppelColor,
              height: screenSize.height * 0.05,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  newData != null ? newData.story : widget.pictory.story,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.05,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
