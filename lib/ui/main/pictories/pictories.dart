import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/pictory/pictory_model.dart';
import 'package:familytree/core/models/pictory/pictorydata_model.dart';
import 'package:familytree/core/viewmodels/views/pictories_view_model.dart';
import 'package:familytree/ui/helper/base_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class PictoriesScreen extends StatefulWidget {
  @override
  _PictoriesScreenState createState() => _PictoriesScreenState();
}

class _PictoriesScreenState extends State<PictoriesScreen> {
  PictoriesViewModel pvm;
  TextEditingController caption = TextEditingController();

  @override
  void dispose() {
    caption.dispose();
    super.dispose();
  }

  void submitPictory() async {
    await pvm.newPictory(
        new PictoryData(caption: caption.text, createdOn: DateTime.now()));
    caption.clear();
    Toast.show(
      'Pictory telah dihantar!',
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
    Navigator.pop(context);
  }

  void newPictory() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.clear,
                    ),
                  ),
                  Spacer(),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: ColorPalette.oceanGreenColor,
                    onPressed: submitPictory,
                    child: Text(
                      'Hantar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              TextField(
                controller: caption,
                maxLines: 3,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: 'Apa yang sedang berlaku?',
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.image,
                      color: ColorPalette.blueSapphireColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
          padding: EdgeInsets.all(40.0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    List<Pictory> pictories = [
      Pictory(
        image:
            'https://content.active.com/Assets/Active.com+Content+Site+Digital+Assets/Outdoors/Articles/Family+Reunion+Games/Carousel.jpg',
        caption: 'Hari bersama atuk dan nenek',
        date: '15 October 2001',
      ),
      Pictory(
        image:
            'https://www.weekendnotes.com/im/000/04/australia-day-family-friendly-events-festivals-act1.jpg',
        caption: 'Hari Keluarga',
        date: '25 Mei 2003',
      ),
      Pictory(
        image:
            'https://res.cloudinary.com/sagacity/image/upload/c_crop,h_640,w_960,x_0,y_0/c_limit,dpr_auto,f_auto,fl_lossy,q_80,w_1080/unnamed_zabwpv.jpg',
        caption: 'Hari Reunion Keluarga',
        date: '30 June 2003',
      ),
      Pictory(
        image:
            'https://s31606.pcdn.co/wp-content/uploads/2018/05/thanksgiving-with-family-picture-id842793126.jpg',
        caption: 'Melawat Kampung',
        date: '18 August 2004',
      ),
      Pictory(
        image: 'https://selangorkini.my/wp-content/uploads/2019/06/raya.jpg',
        caption: 'Hari Raya Aidilfitri',
        date: '1 June 2005',
      ),
    ];

    return BaseWidget<PictoriesViewModel>(
      model: PictoriesViewModel(
        firebaseAuth: FirebaseAuth.instance,
        firestore: Firestore.instance,
      ),
      onModelReady: (model) => model.initializeModel(),
      builder: (context, model, child) => Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Card(
              child: Column(
                children: <Widget>[
                  Image.network(
                    pictories[index].image,
                    fit: BoxFit.cover,
                    width: screenSize.width,
                    height: screenSize.height * 0.2,
                  ),
                  Container(
                    width: screenSize.width,
                    height: screenSize.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pictories[index].caption,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            pictories[index].date,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.78,
            right: screenSize.width * 0.1,
            child: FloatingActionButton(
              onPressed: newPictory,
              child: Icon(Icons.edit),
            ),
          )
        ],
      ),
    );
  }
}
