import 'package:familytree/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key key}) : super(key: key);

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
                'Personal',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.04,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'E-Wallet',
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
            title: Text(
              'Vouchers',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {},
          ),
          Container(
            color: ColorPalette.blueSapphireColor,
            child: ListTile(
              title: Text(
                'Stores',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.04,
                ),
              ),
              onTap: () {
                Toast.show('This feature is currently unavailable', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
          ),
          ListTile(
            title: Text(
              'myKedai',
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
            title: Text(
              'CardsShop',
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
