import 'package:confluence_connect/components/alerts.dart';
import 'package:confluence_connect/models/app_models.dart';
import 'package:confluence_connect/repos/firebase_repo.dart';
import 'package:confluence_connect/screens/home/home_screen.dart';
import 'package:confluence_connect/screens/login/login_screen.dart';
import 'package:confluence_connect/screens/venue%20details/venue_detail.dart';
import 'package:confluence_connect/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  User currentUser;
}

Future<Null> setUserFromSharedPreference() async {
  final SharedPreferences prefs = await sharedPreferences;
  appLogs("setUserFromPreference");
  auth.currentUser = User.fromMap(
    loggedIn: prefs.getBool(APIKeys.loggedIn) ?? false,
    data: getMapFromJson(prefs.getString(APIKeys.userData) ?? ""),
  );
  auth.currentUser.logUser();
}

Future<Null> updateUserInSharedPreference() async {
  appLogs("updateUserInSharedPrefs");

  final SharedPreferences prefs = await sharedPreferences;
  prefs.setBool(APIKeys.loggedIn, auth.currentUser.loggedIn ?? false);
  prefs.setString(APIKeys.userData, getJsonFromMap(auth.currentUser.toMap()));
  auth.currentUser.logUser();
}

redirectUserAsPerStatus(context) async {
  if (auth.currentUser.loggedIn) {
    if (auth.currentUser.attended) {
      AppRoutes.makeFirst(context, HomeScreen());
      return;
    }
    try {
      User user = await FirebaseRepo().getUser(mobile: auth.currentUser.mobile);
      auth.currentUser = user;
      await updateUserInSharedPreference();
      if (auth.currentUser.attended) {
        AppRoutes.makeFirst(context, HomeScreen());
      } else {
        AppRoutes.makeFirst(context, VenueDetails());
      }
    } catch (e) {
      showAlert(context: context, message: Strings.somethingWentWrong, title: "ERROR");
    }
  } else
    AppRoutes.makeFirst(context, LoginScreen());
}
