import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Auth {
  // Register user in server
  static register({
    String uid,
    String name,
    String email,
    String password,
    File image,
    String username,
  }) async {
    var url = Uri.parse('http://pushtiras.co.in/api/register');
    var request = http.MultipartRequest('POST', url);

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['username'] = username;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    request.send().then((response) {
      if (response.statusCode == 200) {
        print('${response.statusCode} - Register success');
      } else {
        print('${response.statusCode} - Register failed');
      }
    });
  }

  // Update Device token in Server
  static updateDeviceToken({String uid, String email}) async {
    String fcmToken = await FirebaseMessaging().getToken();
    var uri =
        'http://pushtiras.co.in/api/updateFcmUid?email=$email?fcm_id=$uid';
    // 'http://pushtiras.co.in/api/updateFcmUid?email=$email?fcm_id=$fcmToken?uid=$uid';
    print('URL === ${uri}');
    var response = await http.post(uri);
    print('fCn Tokrnr=== ${fcmToken}');
    print('uID === ${uid}');
    print('Respoce ==== ${response.body.toString()}');
    if (response.statusCode == 200) {
      print('Record update success');
    } else {
      print('Record update failed');
    }
  }

  static Future<dynamic> checkUserVolunteer(String uid) async {
    var uri = 'http://pushtiras.co.in/api/checkIsVolunteer';
    var response = await http.post(uri, body: {'uid': uid});
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      print('Status ===== ${body}');
      return body['status'];
    } else {
      return 'Network issue';
    }
  }
}
