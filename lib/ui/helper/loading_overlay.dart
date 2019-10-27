import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.black12,
      height: screenSize.height,
      width: screenSize.width,
      child: SpinKitChasingDots(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
