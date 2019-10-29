import 'package:familytree/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoungeScreen extends StatelessWidget {
  const LoungeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            color: ColorPalette.blueSapphireColor,
            child: ListTile(
              title: Text(
                'Bulletin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.04,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info, color: ColorPalette.keppelColor,),
            title: Text(
              'Masalah Longkang Tersumbat',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Toast.show('This feature is currently unavailable', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: ColorPalette.keppelColor,),
            title: Text(
              'Menjaga Kesihatan Anak-Anak',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Toast.show('This feature is currently unavailable', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: ColorPalette.keppelColor,),
            title: Text(
              'Toxic Behavior Dalam Society',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Toast.show('This feature is currently unavailable', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: ColorPalette.keppelColor,),
            title: Text(
              'Menjaga Keselamatan Ketika Melakukan Aktiviti Luar Bersama Keluarga',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Toast.show('This feature is currently unavailable', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: ColorPalette.keppelColor,),
            title: Text(
              'Amalan Menabung',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Toast.show('This feature is currently unavailable', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: ColorPalette.keppelColor,),
            title: Text(
              'Cyberbulling Makin Berleluasa',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Toast.show('This feature is currently unavailable', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: ColorPalette.keppelColor,),
            title: Text(
              'Amalan Kitar Semula',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Toast.show('This feature is currently unavailable', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          ),
        ],
      ),
    );
  }
}
