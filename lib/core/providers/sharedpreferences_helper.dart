import 'dart:convert';

import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String user = 'user';

  static User getUser(SharedPreferences prefs) {
    String userJson = prefs.getString(user);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    } else {
      return null;
    }
  }

  static logUser(SharedPreferences prefs, var userJson) {
    prefs.setString(user, userJson);
  }

  static logOutUser(SharedPreferences prefs) {
    prefs.setString(user, null);
  }
}
