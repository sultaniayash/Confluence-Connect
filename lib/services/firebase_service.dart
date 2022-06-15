import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../app_config.dart';

Firestore firestore = Firestore(app: FirebaseApp(name: App.appName));

class FirestoreCollection {
  static const String masterUser = "master-user";
  static const String schedule = "schedule";
  static const String stalls = "stalls";
  static const String couponType = "coupon_type";
  static const String coupons = "coupons";
  static const String couponsLogs = "coupons-logs";
  static const String guests = "guests";
  static const String app = "app";
  static const String map = "map";
  static const String android = "android";
  static const String ios = "ios";
  static const String version = "version";
}

class FireBaseSettings {
  static const String apiKey = "AIzaSyC1063hsIxv6eb3mn7x8-BMaWsBL_GorlM";
  static const String projectID = "confluence2019-24365";
  static const String gcmSenderID = "1001750066357";
}

class FireBaseSettingsAndroid {
  static const String appName = "ConfluenceConnectANDROID";
  static const String googleAppID = "1:1001750066357:android:93e44ea95f8d6dcfa73afc";
}

class FireBaseSettingsIOS {
  static const String appName = "ConfluenceConnectIOS";
  static const String googleAppID = "1:1001750066357:ios:5bb5ec91a59bbb28a73afc";
}

Future<FirebaseApp> initFirebaseApp() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: Platform.isAndroid ? FireBaseSettingsAndroid.appName : FireBaseSettingsIOS.appName,
    options: FirebaseOptions(
      googleAppID: Platform.isAndroid ? FireBaseSettingsAndroid.googleAppID : FireBaseSettingsIOS.googleAppID,
      gcmSenderID: FireBaseSettings.gcmSenderID,
      apiKey: FireBaseSettings.apiKey,
      projectID: FireBaseSettings.projectID,
    ),
  );
  return app;
}

class FirebaseApi {
  final String path;
  CollectionReference ref;

  FirebaseApi(this.path) {
    ref = firestore.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  DocumentReference getDocumentRef(String id) {
    return ref.document(id);
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<void> addDocument({String id, Map data}) {
    return ref.document(id).setData(data);
  }

  Future<void> updateDocument({String id, Map data}) {
    return ref.document(id).updateData(data);
  }
}
