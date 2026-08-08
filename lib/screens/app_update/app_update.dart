import 'package:app_version_update/app_version_update.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:version/version.dart';

enum UpdateStatus { critical, normal, updated }

class AppUpdate {
  static late Version localVersion;
  static late Version storeVersion;
  // static late Version serverVersion;
  // static late bool criticalUpdate;
  static String? storeUrl;
  static Future<void> init() async {
    AppVersionResult? status;
    // AppUpdateModel? appUpdateModel;
    try {
      // appUpdateModel = await AppUpdateService().getLatestAppUpdate();
      status = await AppVersionUpdate.checkForUpdates(
          appleId: '6739491202',
          playStoreId: 'sa.com.ufc.logistics',
          country: 'SA');
    } catch (e) {
      print(e.toString());
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    localVersion = Version.parse(packageInfo.version);
    storeVersion = Version.parse(status?.storeVersion ?? '0.0.0');
    storeUrl = status?.storeUrl;
    // serverVersion = Version.parse(appUpdateModel?.appVersion ?? '0.0.0');
    // criticalUpdate = appUpdateModel?.isForceUpdate == 1;
  }

  static UpdateStatus updateStatus() {
    if ((storeVersion > localVersion)) {
      // if (criticalUpdate) {
      //   return UpdateStatus.critical;
      // } else {
      return UpdateStatus.normal;
      // }
    } else {
      return UpdateStatus.updated;
    }
  }
}
