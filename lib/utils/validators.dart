import 'package:confluence_connect/utils/app_utils.dart';

class AppValidator {
  static String validateEmail(String value) {
    appLogs("validateEmail : $value ");

    if (value.isEmpty) return Strings.enterEmail;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return Strings.enterValidEmail;
    }

    return null;
  }

  static String validatePhone(String value) {
    if (value.isEmpty) return Strings.enterPhone;

    if (value.contains("/") || value.contains(".") || value.contains(",")) {
      return Strings.enterValidPhone;
    }
    if (value.length < 10) {
      return Strings.enterValidPhone;
    }

    return null;
  }

  static String validateOTP(String value) {
    if (value.isEmpty) return Strings.enterOTP;

    if (value.length < 6) {
      return Strings.enterValidOTP;
    }

    return null;
  }

  static String validateEmptyCheck(String value) {
    if (value.isEmpty) return Strings.emptyMessage;
    return null;
  }
}
