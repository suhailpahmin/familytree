import 'package:familytree/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Tiada akaun?',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenSize.height * 0.018,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutePaths.Register);
            },
            child: Text(
              'Daftar sekarang',
              style: TextStyle(
                color: ColorPalette.keppelColor,
                fontSize: screenSize.height * 0.018,
              ),
            ),
          )
        ],
      ),
    );
  }
}
