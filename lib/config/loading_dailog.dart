import 'dart:io';

// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<T> show<T>(BuildContext context, Future<T> future) async {
    // Show the loading dialog
    showDialog(
      barrierDismissible: kDebugMode,
      context: context,
      builder: (c) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(c).size.width * 0.3,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator.adaptive(
                backgroundColor:
                    Platform.isIOS ? Colors.orangeAccent : Colors.transparent,
                valueColor: const AlwaysStoppedAnimation(Colors.orangeAccent),
              ),
              const SizedBox(height: 15),
              Text('Loading...'),
            ],
          ),
        ),
      ),
    );

    try {
      return await future;
    } catch (e) {
      rethrow;
    } finally {
      // Dismiss the dialog
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
