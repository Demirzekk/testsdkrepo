import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class OhaSdkPlugin {
  static const MethodChannel _channel = MethodChannel('oha_sdk_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// OHA SDK'yı başlatır
  static Future<String?> initializeOHA({
    required String ohaBaseUrl,
    required String primaryColor,
    required String secondaryColor,
    required String appLogoPath,
    required bool isForTesting,
    bool isCloseOnExit = true,
  }) async {
    try {
      // final Map<String, dynamic> arguments = {
      //   'ohaBaseUrl': ohaBaseUrl,
      //   'primaryColor': primaryColor,
      //   'secondaryColor': secondaryColor,
      //   'appLogoPath': appLogoPath,
      //   'isForTesting': isForTesting,
      //   'isCloseOnExit': isCloseOnExit,
      // };

      final String? result = await _channel.invokeMethod('startFlutterSdk', {});

      print('OHA SDK initialized with result: $result');
      return result;
    } catch (e) {
      print('OHA SDK initialization error: $e');
      return null;
    }
  }

  /// AxOnboard servisini başlatır
  static Future<OHAServiceResult?> startAxOnbService({
    required String id,
    required String smsCode,
    required bool isForTesting,
  }) async {
    try {
      final Map<String, dynamic> arguments = {
        'id': id,
        'smsCode': smsCode,
        'isForTesting': isForTesting.toString(),
      };

      final String? result =
          await _channel.invokeMethod('startAxOnbService', arguments);

      if (result != null) {
        final Map<String, dynamic> jsonResult = json.decode(result);
        return OHAServiceResult.fromJson(jsonResult);
      }

      return null;
    } catch (e) {
      print('AxOnboard service error: $e');
      return null;
    }
  }

  /// OHA SDK'yı kapatır
  static Future<String?> closeOHASDK() async {
    try {
      final String? result = await _channel.invokeMethod('closeOHASDK');
      return result;
    } catch (e) {
      print('OHA SDK close error: $e');
      return null;
    }
  }
}

/// OHA servis sonuç modeli
class OHAServiceResult {
  final bool success;
  final String response;

  OHAServiceResult({
    required this.success,
    required this.response,
  });

  factory OHAServiceResult.fromJson(Map<String, dynamic> json) {
    return OHAServiceResult(
      success: json['success'] ?? false,
      response: json['Response'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'Response': response,
    };
  }

  @override
  String toString() {
    return 'OHAServiceResult{success: $success, response: $response}';
  }
}

/// OHA yapılandırma modeli
class OHAConfig {
  final String ohaBaseUrl;
  final String primaryColor;
  final String secondaryColor;
  final String appLogoPath;
  final bool isForTesting;
  final bool isCloseOnExit;

  OHAConfig({
    required this.ohaBaseUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.appLogoPath,
    required this.isForTesting,
    this.isCloseOnExit = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'ohaBaseUrl': ohaBaseUrl,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'appLogoPath': appLogoPath,
      'isForTesting': isForTesting,
      'isCloseOnExit': isCloseOnExit,
    };
  }
}
