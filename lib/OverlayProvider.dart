import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler
import 'package:BlackFlipper/models/item_model.dart';

class OverlayProvider extends ChangeNotifier {
  static const platform = MethodChannel('com.circliks.blackflipper/overlay');
  bool _isOverlayEnabled = false;

  bool get isOverlayEnabled => _isOverlayEnabled;

  OverlayProvider() {
    _checkOverlayStatus();
  }

  Future<void> _checkOverlayStatus() async {
    try {
      final bool isRunning = await platform.invokeMethod('isOverlayRunning');
      _isOverlayEnabled = isRunning;
      notifyListeners();
    } on PlatformException catch (e) {
      print("Failed to check overlay status: '${e.message}'.");
    }
  }


  Future<void> toggleOverlayWithPermission(bool value, {Item? item}) async {
    print("Toggling overlay. Item is: ${item == null ? 'null' : item.toMap().toString()}");
    if (value) {
      if (_isOverlayEnabled) {
        // Overlay is already enabled, just send the new item
        await platform.invokeMethod('startOverlay', item?.toMap());
        return;
      }
      // User wants to enable the overlay
      var status = await Permission.systemAlertWindow.status;
      if (status.isGranted) {
        await platform.invokeMethod('startOverlay', item?.toMap());
        _isOverlayEnabled = true;
      } else {
        // Request the permission
        status = await Permission.systemAlertWindow.request();
        if (status.isGranted) {
          await platform.invokeMethod('startOverlay', item?.toMap());
          _isOverlayEnabled = true;
        } else {
          // Permission denied, inform user and open settings
          // You might want to show a dialog here
          print('System Alert Window permission denied. Please enable it in settings.');
          openAppSettings(); // Opens app settings for the user to manually grant permission
          _isOverlayEnabled = false; // Keep overlay disabled
        }
      }
    } else {
      // User wants to disable the overlay
      await platform.invokeMethod('stopOverlay');
      _isOverlayEnabled = false;
    }
    notifyListeners();
  }
}

