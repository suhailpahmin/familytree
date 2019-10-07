import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userID;
  const HomeScreen({this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
