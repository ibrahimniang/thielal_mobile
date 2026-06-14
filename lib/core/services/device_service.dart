import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;

      return {
        "device_id": android.id,

        "nom_appareil": "${android.brand} ${android.model}",

        "marque": android.brand,

        "modele": android.model,

        "systeme": "Android",

        "version_systeme": android.version.release,
      };
    }

    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;

      return {
        "device_id": ios.identifierForVendor,

        "nom_appareil": ios.name,

        "marque": "Apple",

        "modele": ios.model,

        "systeme": "iOS",

        "version_systeme": ios.systemVersion,
      };
    }

    return {};
  }
}
