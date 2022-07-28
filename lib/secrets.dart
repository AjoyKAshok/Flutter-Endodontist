import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID = "130805577097-hls5bn64qqsqrldm0ff12q5928e2vi7j.apps.googleusercontent.com";
  static const IOS_CLIENT_ID = "130805577097-42dtnmjgh57cb0ck7h05fv59qhao673p.apps.googleusercontent.com";
  static String getId() => Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}