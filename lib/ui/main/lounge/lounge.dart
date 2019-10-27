import 'package:flutter/material.dart';

class LoungeScreen extends StatelessWidget {
  const LoungeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Lounge',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
