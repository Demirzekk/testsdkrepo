import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'oha_sdk_plugin_platform_interface.dart';

/// An implementation of [OhaSdkPluginPlatform] that uses method channels.
class MethodChannelOhaSdkPlugin extends OhaSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('oha_sdk_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
