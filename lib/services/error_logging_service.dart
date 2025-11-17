import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized error logging that pushes failures into the `error_logs` table.
class ErrorLoggingService {
  ErrorLoggingService._();

  static final ErrorLoggingService instance = ErrorLoggingService._();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  SupabaseClient get _client => Supabase.instance.client;

  String? _appVersion;
  String? _platform;
  String? _osVersion;
  String? _deviceModel;
  String? _currentScreen;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await Future.wait([
      _loadAppVersion(),
      _loadDeviceMetadata(),
    ]);
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _appVersion = '${info.version}+${info.buildNumber}';
    } catch (_) {
      _appVersion = null;
    }
  }

  Future<void> _loadDeviceMetadata() async {
    try {
      if (kIsWeb) {
        final info = await _deviceInfo.webBrowserInfo;
        _platform = 'web';
        _osVersion = info.userAgent ?? info.platform ?? 'unknown';
        _deviceModel = info.browserName.name;
        return;
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final info = await _deviceInfo.androidInfo;
          _platform = 'android';
          _osVersion = 'Android ${info.version.release} (SDK ${info.version.sdkInt})';
          _deviceModel = '${info.manufacturer} ${info.model}';
          return;
        case TargetPlatform.iOS:
          final info = await _deviceInfo.iosInfo;
          _platform = 'ios';
          _osVersion = '${info.systemName} ${info.systemVersion}';
          _deviceModel = info.utsname.machine;
          return;
        case TargetPlatform.macOS:
          final info = await _deviceInfo.macOsInfo;
          _platform = 'macos';
          _osVersion = '${info.osRelease} (${info.kernelVersion})';
          _deviceModel = info.model;
          return;
        case TargetPlatform.windows:
          final info = await _deviceInfo.windowsInfo;
          _platform = 'windows';
          final displayVersion = info.displayVersion;
          final productName = info.productName;
          _osVersion = (displayVersion != null && displayVersion.isNotEmpty)
              ? displayVersion
              : ((productName != null && productName.isNotEmpty)
                  ? productName
                  : 'unknown');
          _deviceModel = info.computerName;
          return;
        case TargetPlatform.linux:
          final info = await _deviceInfo.linuxInfo;
          _platform = 'linux';
          final prettyName = info.prettyName;
          final version = info.version;
          final id = info.id;
          _osVersion = (prettyName != null && prettyName.isNotEmpty)
              ? prettyName
              : ((version != null && version.isNotEmpty)
                  ? version
                  : (id ?? 'unknown'));
          _deviceModel = info.machineId ?? 'unknown';
          return;
        case TargetPlatform.fuchsia:
          _platform = 'fuchsia';
          _osVersion = 'unknown';
          _deviceModel = 'unknown';
          return;
      }
    } catch (_) {
      // Fall through to defaults below.
    }

    _platform ??= kIsWeb ? 'web' : defaultTargetPlatform.name.toLowerCase();
    _osVersion ??= 'unknown';
    _deviceModel ??= 'unknown';
  }

  void updateCurrentScreen(String? routeName) {
    _currentScreen = routeName;
  }

  Future<void> logError({
    String? screenName,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extraData,
  }) async {
    final payload = <String, dynamic>{
      'user_id': _client.auth.currentUser?.id,
      'app_version': _appVersion,
      'platform': _platform,
      'os_version': _osVersion,
      'device_model': _deviceModel,
      'screen_name': screenName ?? _currentScreen,
      'error_message': error.toString(),
      'stacktrace': stackTrace?.toString(),
      'extra_data': extraData ?? <String, dynamic>{},
    };

    try {
      await _client.from('error_logs').insert(payload);
    } catch (insertError, insertStackTrace) {
      debugPrint(
        'Failed to write to error_logs: $insertError\n$insertStackTrace',
      );
    }
  }

  /// Wraps an async operation so any caught error is automatically logged.
  Future<T> guard<T>(
    String operationName,
    Future<T> Function() body, {
    String? screenName,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      return await body();
    } catch (error, stackTrace) {
      final combinedExtra = {
        'operation': operationName,
        if (extraData != null) ...extraData,
      };

      unawaited(
        logError(
          screenName: screenName,
          error: error,
          stackTrace: stackTrace,
          extraData: combinedExtra,
        ),
      );
      rethrow;
    }
  }
}
