import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PlatformAdmin {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isAndroidPlatform() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static bool isIOSPlatform() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool isWebPlatform() {
    return defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS;
  }
}
