import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confluence_connect/models/guest.dart';
import 'package:confluence_connect/models/user.dart';
import 'package:confluence_connect/reactive_components/base_reactive_wiget.dart';
import 'package:confluence_connect/services/firebase_service.dart';
import 'package:confluence_connect/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../app_config.dart';

class FirebaseRepo {
  ReactiveRef<Map> getUserRef(String uid) {
    return new ReactiveRef(FirebaseApi(FirestoreCollection.masterUser).getDocumentRef(uid));
  }

  ReactiveRef<Map> getMap() {
    return new ReactiveRef(FirebaseApi(FirestoreCollection.app).getDocumentRef(FirestoreCollection.map));
  }

  Stream<QuerySnapshot> getSchedules() {
    return firestore.collection(FirestoreCollection.schedule).orderBy(APIKeys.startTime).snapshots();
  }

  Stream<QuerySnapshot> getStalls() {
    return firestore.collection(FirestoreCollection.stalls).orderBy(APIKeys.stallNo).snapshots();
  }

  Stream<QuerySnapshot> getCouponType() {
    return firestore.collection(FirestoreCollection.couponType).orderBy(APIKeys.index).snapshots();
  }

  Stream<QuerySnapshot> getActiveCouponType() {
    return firestore
        .collection(FirestoreCollection.couponType)
        .where(APIKeys.isActive, isEqualTo: true)
        .orderBy(APIKeys.index)
        .snapshots();
  }

  Stream<QuerySnapshot> getGuests() {
    return firestore.collection(FirestoreCollection.guests).orderBy(APIKeys.createdAt).snapshots();
  }

  Stream<QuerySnapshot> getUsers() {
    return firestore.collection(FirestoreCollection.masterUser).orderBy(APIKeys.name).snapshots();
  }

  Stream<QuerySnapshot> getCouponEvents(String number, String couponType) {
    return firestore
        .collection(FirestoreCollection.coupons)
        .document(number)
        .collection(couponType)
        .orderBy(APIKeys.updatedAt)
        .snapshots();
  }

  Future<int> getAttendance() async {
    QuerySnapshot querySnapshot = await firestore
        .collection(FirestoreCollection.masterUser)
        .where(APIKeys.attended, isEqualTo: true)
        .getDocuments();
    return querySnapshot.documents.length;
  }

  Future<int> getLunchCount() async {
    int count = 0;
    appLogs("======================");
    QuerySnapshot querySnapshot = await firestore
        .collection(FirestoreCollection.masterUser)
        .where(APIKeys.attended, isEqualTo: true)
        .getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      appLogs('Mobile ${querySnapshot.documents[i].data[APIKeys.mobile]}');
      QuerySnapshot subQuery = await firestore
          .collection(FirestoreCollection.coupons)
          .document(querySnapshot.documents[i].data[APIKeys.mobile])
          .collection('Lunch')
          .getDocuments();

      for (int j = 0; j < subQuery.documents.length; j++) {
        appLogs("Lunch : ${subQuery.documents[j].data[APIKeys.used]}");
        if (subQuery.documents[j].data[APIKeys.used] ?? false) count++;
      }
      appLogs('Count : $count');
    }

    return count;
  }

  Future<Null> updateEvent({
    @required String number,
    @required String couponType,
    @required String eventId,
  }) async {
    await firestore
        .collection(FirestoreCollection.coupons)
        .document(number)
        .collection(couponType)
        .document(eventId)
        .updateData({
      APIKeys.updatedAt: Timestamp.now(),
      APIKeys.used: true,
    }).catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
  }

  Future<Null> updateUser({
    @required String number,
  }) async {
    await firestore.collection(FirestoreCollection.masterUser).document(number).updateData({
      APIKeys.updatedAt: Timestamp.now(),
      APIKeys.attended: true,
    }).catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
  }

  Future<Null> updateCouponType({
    @required String id,
    @required bool flag,
  }) async {
    await firestore.collection(FirestoreCollection.couponType).document(id).updateData({
      APIKeys.updatedAt: Timestamp.now(),
      APIKeys.isActive: flag,
    }).catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
  }

  Future<Null> addGuest({
    @required Guest guest,
  }) async {
    await firestore.collection(FirestoreCollection.guests).document().setData(guest.toMap()).catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
  }

  Future<Null> addUser({
    @required User user,
  }) async {
    await firestore
        .collection(FirestoreCollection.masterUser)
        .document(user.mobile)
        .setData(user.toMap())
        .catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
  }

  Future<Null> addCoupon({
    @required String mobile,
    @required String type,
  }) async {
    await firestore
        .collection(FirestoreCollection.coupons)
        .document(mobile)
        .collection(type)
        .document()
        .setData({APIKeys.used: false, APIKeys.updatedAt: Timestamp.now()}).catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
    await firestore.collection(FirestoreCollection.couponsLogs).document().setData({
      APIKeys.mobile: mobile,
      APIKeys.createdBy: auth.currentUser.mobile,
      APIKeys.coupon: type,
      APIKeys.createdAt: Timestamp.now(),
    }).catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
  }

  Future<bool> checkUserInMaster({
    @required String mobile,
  }) async {
    appLogs("checkUserInMaster mobile $mobile");

    QuerySnapshot querySnapshot = await firestore
        .collection(FirestoreCollection.masterUser)
        .where(APIKeys.mobile, isEqualTo: mobile)
        .getDocuments()
        .catchError((error) {
      appLogs("error $error");
      appLogs("error $error");
    });
    appLogs("checkUserInMaster ${querySnapshot.documents.toString()}");

    return querySnapshot.documents.length > 0;
  }

  Future<bool> checkAppUpdate() async {
    appLogs("checkAppUpdate");

    DocumentSnapshot documentSnapshot = await firestore
        .collection(FirestoreCollection.app)
        .document(FirestoreCollection.version)
        .get()
        .catchError((error) {
      appLogs("error $error");
      appLogs("error $error");
    });
    appLogs("checkAppUpdate ${documentSnapshot.data.toString()}");
    if (documentSnapshot?.data != null) {
      int versionCode =
          documentSnapshot.data[Platform.isAndroid ? FirestoreCollection.android : FirestoreCollection.ios] ?? 0;
      if (versionCode > App.versionCode) return true;
    }
    return false;
  }

  Future<User> getUser({
    @required String mobile,
  }) async {
    DocumentSnapshot querySnapshot =
        await firestore.collection(FirestoreCollection.masterUser).document(mobile).get().catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
    User user = User.fromMap(loggedIn: true, data: querySnapshot.data);
    return user;
  }

  Future<void> getTest() async {
    appLogs("getTest=====\n=====\n");
    DocumentSnapshot documentSnapshot = await FirebaseApi(FirestoreCollection.masterUser).getDocumentById('7875056731');
    appLogs("documentSnapshot : ${documentSnapshot.data}");
    appLogs("documentSnapshot documentID:${documentSnapshot.documentID}");
    appLogs("getTest=====\n=====\n");
  }

  Future<Null> updateGuest({
    @required Guest guest,
  }) async {
    await firestore.collection(FirestoreCollection.guests).document(guest.id).updateData({
      APIKeys.confirmed: true,
    }).catchError((_) {
      throw PlatformException(
        code: "",
        message: "",
      );
    });
  }
}
