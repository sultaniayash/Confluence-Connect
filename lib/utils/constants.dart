import 'package:confluence_connect/services/app_services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String logTAG = "LOGS";
const String apiTAG = "API";
const String screenTag = "SCREEN";

const int otpTimeOutInSeconds = 30;
const int mobileNumberLength = 10;
const int timeOutCode = 504;
const int serverErrorCode = 500;
const int timeOutSecond = 30;
const int errorStatusCode = 0;
const int minChildrenCount = 9;

final auth = new Auth();

DateFormat dateReadFormatter = DateFormat('dd MMM yyyy,').add_jm();
DateFormat dateSendFormatter = DateFormat('yyyy-MM-dd');
DateFormat timeFormatter = DateFormat('').add_jm();

Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

class Constant {
  /*Delay Constants*/

  static const int delayExtraSmall = 100;
  static const int delaySmall = 200;
  static const int delayMedium = 700;
  static const int delayLarge = 1000;
  static const int delayXL = 1500;
  static const int delayXXL = 2000;

  static const int emailVerificationCallBack = 10000;

  static const double cardElevation = 5.0;
  static const double lineHeight = 0.5;
  static const int dashNumber = 8;
  static const int dashNumberVertical = 25;
  static const int dashNumberVertical2 = 15;
  static const int personalInformationFocusNodes = 5;
  static const int companyInformationFocusNodes = 6;
  static const int flex = 1;
  static const int maxLineAppBar = 2;
  static const int paymentAmount = 400000;
}
