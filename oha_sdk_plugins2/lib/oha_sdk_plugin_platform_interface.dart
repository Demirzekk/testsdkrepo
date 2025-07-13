import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'oha_sdk_plugin_method_channel.dart';

abstract class OhaSdkPluginPlatform extends PlatformInterface {
  /// Constructs a OhaSdkPluginPlatform.
  OhaSdkPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static OhaSdkPluginPlatform _instance = MethodChannelOhaSdkPlugin();

  /// The default instance of [OhaSdkPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelOhaSdkPlugin].
  static OhaSdkPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OhaSdkPluginPlatform] when
  /// they register themselves.
  static set instance(OhaSdkPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
