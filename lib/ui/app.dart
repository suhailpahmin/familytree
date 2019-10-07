import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/constants/router.dart';
import 'package:familytree/ui/root.dart';
import 'package:flutter/material.dart';

class FamilyTreeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootScreen(),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: RoutePaths.Root,
      onGenerateRoute: Router.generateRoute,
    );
  }
}
