import 'dart:convert';

import 'package:confluence_connect/app_config.dart';
import 'package:confluence_connect/components/alerts.dart';
import 'package:confluence_connect/services/app_services.dart';
import 'package:confluence_connect/theme/app_theme.dart';
import 'package:confluence_connect/utils/app_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

appLogs(Object object, {String tag = 'APPLOGS'}) {
  if (App.appLog) {
    String message = "$object";

    int maxLogSize = 1000;
    for (int i = 0; i <= message.length / maxLogSize; i++) {
      int start = i * maxLogSize;
      int end = (i + 1) * maxLogSize;
      end = end > message.length ? message.length : end;
      print("$tag : ${message.substring(start, end)}");
    }
  }
}

apiLogs(Object object, {String tag = 'API'}) {
  if (App.apiLog) {
    String message = "$object";

    int maxLogSize = 1000;
    for (int i = 0; i <= message.length / maxLogSize; i++) {
      int start = i * maxLogSize;
      int end = (i + 1) * maxLogSize;
      end = end > message.length ? message.length : end;
      print("$tag : ${message.substring(start, end)}");
    }
  }
}

setFocus(BuildContext context, {FocusNode focusNode}) {
  FocusScope.of(context).requestFocus(focusNode ?? FocusNode());
}

showSnackBar({
  @required String title,
  @required GlobalKey<ScaffoldState> scaffoldKey,
  Color color,
  int milliseconds = Constant.delayXXL,
  TextStyle style,
}) {
  scaffoldKey.currentState?.showSnackBar(
    new SnackBar(
      backgroundColor: color ?? AppColors.primary,
      duration: Duration(milliseconds: milliseconds),
      content: Container(
        constraints: BoxConstraints(minHeight: Sizes.snackBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              title,
              style: style ?? TextStyles.snackBarText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> isConnected() async {
  DateTime start = new DateTime.now();
  var connectivityResult = await (new Connectivity().checkConnectivity());
  bool result = false;
  if (connectivityResult != ConnectivityResult.none) result = true;
  if (result) {
    Response response = await Dio().get("https://google.com");
    result = response.statusCode == 200;
  }
  DateTime end = new DateTime.now();

  appLogs("=== ==isConnected== ===${end.difference(start).inMilliseconds} inMilliseconds");

  return result;
}

Future<Null> performIfConnected({
  @required GestureTapCallback callBack,
  @required BuildContext context,
  bool exitOption = false,
}) async {
  appLogs("performIfConnected ------>Called ");

  if (await isConnected()) {
    appLogs("performIfConnected ------>Connected----->callBack called ");
    callBack();
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppAlert(
        title: "",
        positiveButtonOnTap: () async {
          appLogs("performIfConnected ------>Not Connected----->Retry ");
          performIfConnected(
            callBack: callBack,
            context: context,
            exitOption: exitOption,
          );
        },
        positiveButtonText: Strings.retry,
        negativeButtonOnTap: exitOption
            ? () async {
                appLogs("performIfConnected ------>Not Connected----->Exit ");

                SystemNavigator.pop();
              }
            : () {
                appLogs("performIfConnected ------>Not Connected----->Pop ");
              },
        negativeButtonText: exitOption ? Strings.exit : Strings.negativeButtonText,
        message: Strings.notConnected,
      ),
    );
  }
}

bool isFormValid(key) {
  final form = key.currentState;
  if (form.validate()) {
    form.save();
    appLogs('$key isFormValid:true');

    return true;
  }
  appLogs('$key isFormValid:false');

  return false;
}

hideStatusBar() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
}

showStatusBar() async {
  await Future.delayed(Duration(milliseconds: Constant.delayMedium));
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
}

setStatusBarColor({Color color}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: color ?? AppColors.primary,
  ));
}

changeStatusColor(Color color, {bool whiteForeground = false}) async {
  try {
    await Future.delayed(Duration(milliseconds: Constant.delayMedium));
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(whiteForeground);
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}

resetStatusBarColor() {
  SystemChrome.restoreSystemUIOverlays();
}

String getJsonFromMap(Map mapData) {
  String data = "";

  try {
    data = json.encode(mapData);
  } catch (e, s) {
    appLogs("Error in getJsonFromMap\n\n *$mapData* \n\n $e\n\n$s");
  }

  return data;
}

Map getMapFromJson(String mapData) {
  Map data = Map();

  try {
    if (mapData.isEmpty) return data;
    data = json.decode(mapData);
  } catch (e, s) {
    appLogs("Error in getMapFromJson\n\n *$mapData* \n\n $e\n\n$s");
  }

  return data;
}

int toINT(Object value) {
  if (value != null) {
    try {
      int number = int.tryParse('$value');
      return number;
    } on Exception catch (e, s) {
      appLogs("toINT Exception : $e\n$s");

      return 0;
    }
  }
  return 0;
}

double toDouble(Object value) {
  if (value != null) {
    try {
      double number = double.tryParse('$value') ?? 0.0;
      return number;
    } on Exception catch (e, s) {
      appLogs("toDouble Exception : $e\n$s");
      return 0;
    }
  }
  return 0;
}

callNumber(String userMobileNumber) async {
  String url = "tel:$userMobileNumber";
  await launchURL(url);
}

sendEmail(String email) async {
  String url = "mailto:$email";
  await launchURL(url);
}

DateTime getDateFromString(String value) {
//  appLogs("getDateFromString value is $value");
  DateTime tempDateTime = DateTime.now();

  try {
    if (value == null) {
      return DateTime.now();
    } else {
      value = value.toString().replaceAll("/", "-");
    }

    tempDateTime = DateTime.tryParse(value);
  } catch (e, s) {
    appLogs("Error in getDateFromString ${e.toString()}\n$s");
    return DateTime.now();
  }

  appLogs("getDateFromString ${tempDateTime.toString()}");

  return tempDateTime;
}

addIfNotEmpty({
  @required String key,
  @required String value,
  @required Map<String, dynamic> parameterData,
}) {
  if (value.isNotEmpty) {
    parameterData.putIfAbsent(key, () => value);
  }
}
