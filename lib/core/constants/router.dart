import 'package:familytree/core/constants/app_constants.dart';
import 'package:familytree/core/models/authentication/firsttime_model.dart';
import 'package:familytree/ui/authentication/login.dart';
import 'package:familytree/ui/authentication/register.dart';
import 'package:familytree/ui/main/firsttime.dart';
import 'package:familytree/ui/main/home.dart';
import 'package:familytree/ui/root.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RoutePaths.FirstTime:
        FirstTime firstTime = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => FirstTimeScreen(
            firstTime: firstTime,
          ),
        );
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutePaths.Root:
        return MaterialPageRoute(builder: (_) => RootScreen());
      case RoutePaths.Register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
