import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/error_logging_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'error_logging_service_test.mocks.dart';

@GenerateMocks([
  DeviceInfoPlugin,
  PackageInfo,
  AndroidDeviceInfo,
  IosDeviceInfo,
  AndroidBuildVersion,
  IosUtsname,
])
void main() {
  late MockDeviceInfoPlugin mockDeviceInfo;
  late MockPackageInfo mockPackageInfo;
  late ErrorLoggingService service;

  setUp(() {
    mockDeviceInfo = MockDeviceInfoPlugin();
    mockPackageInfo = MockPackageInfo();

    // Default stubs
    when(mockPackageInfo.version).thenReturn('1.0.0');
    when(mockPackageInfo.buildNumber).thenReturn('1');
  });

  Future<PackageInfo> mockPackageInfoLoader() async {
    return mockPackageInfo;
  }

  group('ErrorLoggingService', () {
    test('initializes correctly and loads app version', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final mockAndroidInfo = MockAndroidDeviceInfo();
      final mockAndroidBuildVersion = MockAndroidBuildVersion();

      when(mockAndroidBuildVersion.release).thenReturn('12');
      when(mockAndroidBuildVersion.sdkInt).thenReturn(31);

      when(mockAndroidInfo.version).thenReturn(mockAndroidBuildVersion);
      when(mockAndroidInfo.manufacturer).thenReturn('Google');
      when(mockAndroidInfo.model).thenReturn('Pixel 6');

      when(mockDeviceInfo.androidInfo).thenAnswer((_) async => mockAndroidInfo);

      service = ErrorLoggingService.test(
        deviceInfo: mockDeviceInfo,
        packageInfoLoader: mockPackageInfoLoader,
      );

      await service.init();

      expect(service.appVersion, '1.0.0+1');
      expect(service.platform, 'android');
      expect(service.osVersion, 'Android 12 (SDK 31)');
      expect(service.deviceModel, 'Google Pixel 6');

      debugDefaultTargetPlatformOverride = null;
    });

    test('handles iOS platform', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      final mockIosInfo = MockIosDeviceInfo();
      final mockIosUtsname = MockIosUtsname();

      when(mockIosUtsname.machine).thenReturn('iPhone13,1');

      when(mockIosInfo.systemName).thenReturn('iOS');
      when(mockIosInfo.systemVersion).thenReturn('15.0');
      when(mockIosInfo.utsname).thenReturn(mockIosUtsname);

      when(mockDeviceInfo.iosInfo).thenAnswer((_) async => mockIosInfo);

      service = ErrorLoggingService.test(
        deviceInfo: mockDeviceInfo,
        packageInfoLoader: mockPackageInfoLoader,
      );

      await service.init();

      expect(service.platform, 'ios');
      expect(service.osVersion, 'iOS 15.0');
      expect(service.deviceModel, 'iPhone13,1');

      debugDefaultTargetPlatformOverride = null;
    });

    test('handles package info load failure', () async {
      service = ErrorLoggingService.test(
        deviceInfo: mockDeviceInfo,
        packageInfoLoader: () async => throw Exception('Failed to load'),
      );

      // Mock device info to avoid crash
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final mockAndroidInfo = MockAndroidDeviceInfo();
      final mockAndroidBuildVersion = MockAndroidBuildVersion();

      when(mockAndroidBuildVersion.release).thenReturn('12');
      when(mockAndroidBuildVersion.sdkInt).thenReturn(31);

      when(mockAndroidInfo.version).thenReturn(mockAndroidBuildVersion);
      when(mockAndroidInfo.manufacturer).thenReturn('Google');
      when(mockAndroidInfo.model).thenReturn('Pixel 6');

      when(mockDeviceInfo.androidInfo).thenAnswer((_) async => mockAndroidInfo);

      await service.init();

      expect(service.appVersion, isNull);

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
