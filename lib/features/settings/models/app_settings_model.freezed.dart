// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  // UI Settings
  bool get darkMode => throw _privateConstructorUsedError;
  double get fontSize => throw _privateConstructorUsedError;
  bool get compactMode => throw _privateConstructorUsedError;
  String get language =>
      throw _privateConstructorUsedError; // Notification Settings
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  bool get dailyCheckinReminder => throw _privateConstructorUsedError;
  String get checkinReminderTime => throw _privateConstructorUsedError;
  bool get medicationReminders => throw _privateConstructorUsedError;
  bool get cravingAlerts => throw _privateConstructorUsedError;
  bool get weeklyReports =>
      throw _privateConstructorUsedError; // Privacy Settings
  bool get biometricLock => throw _privateConstructorUsedError;
  bool get requirePinOnOpen => throw _privateConstructorUsedError;
  String get autoLockDuration =>
      throw _privateConstructorUsedError; // '1min', '5min', '15min', 'never'
  bool get hideContentInRecents => throw _privateConstructorUsedError;
  bool get analyticsEnabled =>
      throw _privateConstructorUsedError; // Data Settings
  bool get autoBackup => throw _privateConstructorUsedError;
  String get backupFrequency =>
      throw _privateConstructorUsedError; // 'daily', 'weekly', 'monthly'
  bool get syncEnabled => throw _privateConstructorUsedError;
  bool get offlineMode => throw _privateConstructorUsedError;
  bool get cacheEnabled => throw _privateConstructorUsedError;
  String get cacheDuration =>
      throw _privateConstructorUsedError; // '1hour', '6hours', '1day'
  // Entry Settings
  String get defaultDoseUnit => throw _privateConstructorUsedError;
  bool get quickEntryMode => throw _privateConstructorUsedError;
  bool get autoSaveEntries => throw _privateConstructorUsedError;
  bool get showRecentSubstances => throw _privateConstructorUsedError;
  int get recentSubstancesCount =>
      throw _privateConstructorUsedError; // Display Settings
  bool get show24HourTime => throw _privateConstructorUsedError;
  String get dateFormat =>
      throw _privateConstructorUsedError; // 'MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'
  bool get showBloodLevels => throw _privateConstructorUsedError;
  bool get showAnalytics => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    bool darkMode,
    double fontSize,
    bool compactMode,
    String language,
    bool notificationsEnabled,
    bool dailyCheckinReminder,
    String checkinReminderTime,
    bool medicationReminders,
    bool cravingAlerts,
    bool weeklyReports,
    bool biometricLock,
    bool requirePinOnOpen,
    String autoLockDuration,
    bool hideContentInRecents,
    bool analyticsEnabled,
    bool autoBackup,
    String backupFrequency,
    bool syncEnabled,
    bool offlineMode,
    bool cacheEnabled,
    String cacheDuration,
    String defaultDoseUnit,
    bool quickEntryMode,
    bool autoSaveEntries,
    bool showRecentSubstances,
    int recentSubstancesCount,
    bool show24HourTime,
    String dateFormat,
    bool showBloodLevels,
    bool showAnalytics,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkMode = null,
    Object? fontSize = null,
    Object? compactMode = null,
    Object? language = null,
    Object? notificationsEnabled = null,
    Object? dailyCheckinReminder = null,
    Object? checkinReminderTime = null,
    Object? medicationReminders = null,
    Object? cravingAlerts = null,
    Object? weeklyReports = null,
    Object? biometricLock = null,
    Object? requirePinOnOpen = null,
    Object? autoLockDuration = null,
    Object? hideContentInRecents = null,
    Object? analyticsEnabled = null,
    Object? autoBackup = null,
    Object? backupFrequency = null,
    Object? syncEnabled = null,
    Object? offlineMode = null,
    Object? cacheEnabled = null,
    Object? cacheDuration = null,
    Object? defaultDoseUnit = null,
    Object? quickEntryMode = null,
    Object? autoSaveEntries = null,
    Object? showRecentSubstances = null,
    Object? recentSubstancesCount = null,
    Object? show24HourTime = null,
    Object? dateFormat = null,
    Object? showBloodLevels = null,
    Object? showAnalytics = null,
  }) {
    return _then(
      _value.copyWith(
            darkMode: null == darkMode
                ? _value.darkMode
                : darkMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            fontSize: null == fontSize
                ? _value.fontSize
                : fontSize // ignore: cast_nullable_to_non_nullable
                      as double,
            compactMode: null == compactMode
                ? _value.compactMode
                : compactMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            language: null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String,
            notificationsEnabled: null == notificationsEnabled
                ? _value.notificationsEnabled
                : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            dailyCheckinReminder: null == dailyCheckinReminder
                ? _value.dailyCheckinReminder
                : dailyCheckinReminder // ignore: cast_nullable_to_non_nullable
                      as bool,
            checkinReminderTime: null == checkinReminderTime
                ? _value.checkinReminderTime
                : checkinReminderTime // ignore: cast_nullable_to_non_nullable
                      as String,
            medicationReminders: null == medicationReminders
                ? _value.medicationReminders
                : medicationReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            cravingAlerts: null == cravingAlerts
                ? _value.cravingAlerts
                : cravingAlerts // ignore: cast_nullable_to_non_nullable
                      as bool,
            weeklyReports: null == weeklyReports
                ? _value.weeklyReports
                : weeklyReports // ignore: cast_nullable_to_non_nullable
                      as bool,
            biometricLock: null == biometricLock
                ? _value.biometricLock
                : biometricLock // ignore: cast_nullable_to_non_nullable
                      as bool,
            requirePinOnOpen: null == requirePinOnOpen
                ? _value.requirePinOnOpen
                : requirePinOnOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoLockDuration: null == autoLockDuration
                ? _value.autoLockDuration
                : autoLockDuration // ignore: cast_nullable_to_non_nullable
                      as String,
            hideContentInRecents: null == hideContentInRecents
                ? _value.hideContentInRecents
                : hideContentInRecents // ignore: cast_nullable_to_non_nullable
                      as bool,
            analyticsEnabled: null == analyticsEnabled
                ? _value.analyticsEnabled
                : analyticsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoBackup: null == autoBackup
                ? _value.autoBackup
                : autoBackup // ignore: cast_nullable_to_non_nullable
                      as bool,
            backupFrequency: null == backupFrequency
                ? _value.backupFrequency
                : backupFrequency // ignore: cast_nullable_to_non_nullable
                      as String,
            syncEnabled: null == syncEnabled
                ? _value.syncEnabled
                : syncEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            offlineMode: null == offlineMode
                ? _value.offlineMode
                : offlineMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            cacheEnabled: null == cacheEnabled
                ? _value.cacheEnabled
                : cacheEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            cacheDuration: null == cacheDuration
                ? _value.cacheDuration
                : cacheDuration // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultDoseUnit: null == defaultDoseUnit
                ? _value.defaultDoseUnit
                : defaultDoseUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            quickEntryMode: null == quickEntryMode
                ? _value.quickEntryMode
                : quickEntryMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoSaveEntries: null == autoSaveEntries
                ? _value.autoSaveEntries
                : autoSaveEntries // ignore: cast_nullable_to_non_nullable
                      as bool,
            showRecentSubstances: null == showRecentSubstances
                ? _value.showRecentSubstances
                : showRecentSubstances // ignore: cast_nullable_to_non_nullable
                      as bool,
            recentSubstancesCount: null == recentSubstancesCount
                ? _value.recentSubstancesCount
                : recentSubstancesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            show24HourTime: null == show24HourTime
                ? _value.show24HourTime
                : show24HourTime // ignore: cast_nullable_to_non_nullable
                      as bool,
            dateFormat: null == dateFormat
                ? _value.dateFormat
                : dateFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            showBloodLevels: null == showBloodLevels
                ? _value.showBloodLevels
                : showBloodLevels // ignore: cast_nullable_to_non_nullable
                      as bool,
            showAnalytics: null == showAnalytics
                ? _value.showAnalytics
                : showAnalytics // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool darkMode,
    double fontSize,
    bool compactMode,
    String language,
    bool notificationsEnabled,
    bool dailyCheckinReminder,
    String checkinReminderTime,
    bool medicationReminders,
    bool cravingAlerts,
    bool weeklyReports,
    bool biometricLock,
    bool requirePinOnOpen,
    String autoLockDuration,
    bool hideContentInRecents,
    bool analyticsEnabled,
    bool autoBackup,
    String backupFrequency,
    bool syncEnabled,
    bool offlineMode,
    bool cacheEnabled,
    String cacheDuration,
    String defaultDoseUnit,
    bool quickEntryMode,
    bool autoSaveEntries,
    bool showRecentSubstances,
    int recentSubstancesCount,
    bool show24HourTime,
    String dateFormat,
    bool showBloodLevels,
    bool showAnalytics,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkMode = null,
    Object? fontSize = null,
    Object? compactMode = null,
    Object? language = null,
    Object? notificationsEnabled = null,
    Object? dailyCheckinReminder = null,
    Object? checkinReminderTime = null,
    Object? medicationReminders = null,
    Object? cravingAlerts = null,
    Object? weeklyReports = null,
    Object? biometricLock = null,
    Object? requirePinOnOpen = null,
    Object? autoLockDuration = null,
    Object? hideContentInRecents = null,
    Object? analyticsEnabled = null,
    Object? autoBackup = null,
    Object? backupFrequency = null,
    Object? syncEnabled = null,
    Object? offlineMode = null,
    Object? cacheEnabled = null,
    Object? cacheDuration = null,
    Object? defaultDoseUnit = null,
    Object? quickEntryMode = null,
    Object? autoSaveEntries = null,
    Object? showRecentSubstances = null,
    Object? recentSubstancesCount = null,
    Object? show24HourTime = null,
    Object? dateFormat = null,
    Object? showBloodLevels = null,
    Object? showAnalytics = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        darkMode: null == darkMode
            ? _value.darkMode
            : darkMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        fontSize: null == fontSize
            ? _value.fontSize
            : fontSize // ignore: cast_nullable_to_non_nullable
                  as double,
        compactMode: null == compactMode
            ? _value.compactMode
            : compactMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String,
        notificationsEnabled: null == notificationsEnabled
            ? _value.notificationsEnabled
            : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyCheckinReminder: null == dailyCheckinReminder
            ? _value.dailyCheckinReminder
            : dailyCheckinReminder // ignore: cast_nullable_to_non_nullable
                  as bool,
        checkinReminderTime: null == checkinReminderTime
            ? _value.checkinReminderTime
            : checkinReminderTime // ignore: cast_nullable_to_non_nullable
                  as String,
        medicationReminders: null == medicationReminders
            ? _value.medicationReminders
            : medicationReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        cravingAlerts: null == cravingAlerts
            ? _value.cravingAlerts
            : cravingAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        weeklyReports: null == weeklyReports
            ? _value.weeklyReports
            : weeklyReports // ignore: cast_nullable_to_non_nullable
                  as bool,
        biometricLock: null == biometricLock
            ? _value.biometricLock
            : biometricLock // ignore: cast_nullable_to_non_nullable
                  as bool,
        requirePinOnOpen: null == requirePinOnOpen
            ? _value.requirePinOnOpen
            : requirePinOnOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoLockDuration: null == autoLockDuration
            ? _value.autoLockDuration
            : autoLockDuration // ignore: cast_nullable_to_non_nullable
                  as String,
        hideContentInRecents: null == hideContentInRecents
            ? _value.hideContentInRecents
            : hideContentInRecents // ignore: cast_nullable_to_non_nullable
                  as bool,
        analyticsEnabled: null == analyticsEnabled
            ? _value.analyticsEnabled
            : analyticsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoBackup: null == autoBackup
            ? _value.autoBackup
            : autoBackup // ignore: cast_nullable_to_non_nullable
                  as bool,
        backupFrequency: null == backupFrequency
            ? _value.backupFrequency
            : backupFrequency // ignore: cast_nullable_to_non_nullable
                  as String,
        syncEnabled: null == syncEnabled
            ? _value.syncEnabled
            : syncEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        offlineMode: null == offlineMode
            ? _value.offlineMode
            : offlineMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        cacheEnabled: null == cacheEnabled
            ? _value.cacheEnabled
            : cacheEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        cacheDuration: null == cacheDuration
            ? _value.cacheDuration
            : cacheDuration // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultDoseUnit: null == defaultDoseUnit
            ? _value.defaultDoseUnit
            : defaultDoseUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        quickEntryMode: null == quickEntryMode
            ? _value.quickEntryMode
            : quickEntryMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoSaveEntries: null == autoSaveEntries
            ? _value.autoSaveEntries
            : autoSaveEntries // ignore: cast_nullable_to_non_nullable
                  as bool,
        showRecentSubstances: null == showRecentSubstances
            ? _value.showRecentSubstances
            : showRecentSubstances // ignore: cast_nullable_to_non_nullable
                  as bool,
        recentSubstancesCount: null == recentSubstancesCount
            ? _value.recentSubstancesCount
            : recentSubstancesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        show24HourTime: null == show24HourTime
            ? _value.show24HourTime
            : show24HourTime // ignore: cast_nullable_to_non_nullable
                  as bool,
        dateFormat: null == dateFormat
            ? _value.dateFormat
            : dateFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        showBloodLevels: null == showBloodLevels
            ? _value.showBloodLevels
            : showBloodLevels // ignore: cast_nullable_to_non_nullable
                  as bool,
        showAnalytics: null == showAnalytics
            ? _value.showAnalytics
            : showAnalytics // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    this.darkMode = false,
    this.fontSize = 14.0,
    this.compactMode = false,
    this.language = 'en',
    this.notificationsEnabled = true,
    this.dailyCheckinReminder = true,
    this.checkinReminderTime = '09:00',
    this.medicationReminders = true,
    this.cravingAlerts = true,
    this.weeklyReports = false,
    this.biometricLock = false,
    this.requirePinOnOpen = false,
    this.autoLockDuration = '5min',
    this.hideContentInRecents = false,
    this.analyticsEnabled = false,
    this.autoBackup = false,
    this.backupFrequency = 'weekly',
    this.syncEnabled = true,
    this.offlineMode = false,
    this.cacheEnabled = true,
    this.cacheDuration = '1hour',
    this.defaultDoseUnit = 'mg',
    this.quickEntryMode = false,
    this.autoSaveEntries = true,
    this.showRecentSubstances = true,
    this.recentSubstancesCount = 5,
    this.show24HourTime = false,
    this.dateFormat = 'MM/DD/YYYY',
    this.showBloodLevels = true,
    this.showAnalytics = true,
  });

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  // UI Settings
  @override
  @JsonKey()
  final bool darkMode;
  @override
  @JsonKey()
  final double fontSize;
  @override
  @JsonKey()
  final bool compactMode;
  @override
  @JsonKey()
  final String language;
  // Notification Settings
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  @JsonKey()
  final bool dailyCheckinReminder;
  @override
  @JsonKey()
  final String checkinReminderTime;
  @override
  @JsonKey()
  final bool medicationReminders;
  @override
  @JsonKey()
  final bool cravingAlerts;
  @override
  @JsonKey()
  final bool weeklyReports;
  // Privacy Settings
  @override
  @JsonKey()
  final bool biometricLock;
  @override
  @JsonKey()
  final bool requirePinOnOpen;
  @override
  @JsonKey()
  final String autoLockDuration;
  // '1min', '5min', '15min', 'never'
  @override
  @JsonKey()
  final bool hideContentInRecents;
  @override
  @JsonKey()
  final bool analyticsEnabled;
  // Data Settings
  @override
  @JsonKey()
  final bool autoBackup;
  @override
  @JsonKey()
  final String backupFrequency;
  // 'daily', 'weekly', 'monthly'
  @override
  @JsonKey()
  final bool syncEnabled;
  @override
  @JsonKey()
  final bool offlineMode;
  @override
  @JsonKey()
  final bool cacheEnabled;
  @override
  @JsonKey()
  final String cacheDuration;
  // '1hour', '6hours', '1day'
  // Entry Settings
  @override
  @JsonKey()
  final String defaultDoseUnit;
  @override
  @JsonKey()
  final bool quickEntryMode;
  @override
  @JsonKey()
  final bool autoSaveEntries;
  @override
  @JsonKey()
  final bool showRecentSubstances;
  @override
  @JsonKey()
  final int recentSubstancesCount;
  // Display Settings
  @override
  @JsonKey()
  final bool show24HourTime;
  @override
  @JsonKey()
  final String dateFormat;
  // 'MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'
  @override
  @JsonKey()
  final bool showBloodLevels;
  @override
  @JsonKey()
  final bool showAnalytics;

  @override
  String toString() {
    return 'AppSettings(darkMode: $darkMode, fontSize: $fontSize, compactMode: $compactMode, language: $language, notificationsEnabled: $notificationsEnabled, dailyCheckinReminder: $dailyCheckinReminder, checkinReminderTime: $checkinReminderTime, medicationReminders: $medicationReminders, cravingAlerts: $cravingAlerts, weeklyReports: $weeklyReports, biometricLock: $biometricLock, requirePinOnOpen: $requirePinOnOpen, autoLockDuration: $autoLockDuration, hideContentInRecents: $hideContentInRecents, analyticsEnabled: $analyticsEnabled, autoBackup: $autoBackup, backupFrequency: $backupFrequency, syncEnabled: $syncEnabled, offlineMode: $offlineMode, cacheEnabled: $cacheEnabled, cacheDuration: $cacheDuration, defaultDoseUnit: $defaultDoseUnit, quickEntryMode: $quickEntryMode, autoSaveEntries: $autoSaveEntries, showRecentSubstances: $showRecentSubstances, recentSubstancesCount: $recentSubstancesCount, show24HourTime: $show24HourTime, dateFormat: $dateFormat, showBloodLevels: $showBloodLevels, showAnalytics: $showAnalytics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.darkMode, darkMode) ||
                other.darkMode == darkMode) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.compactMode, compactMode) ||
                other.compactMode == compactMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.dailyCheckinReminder, dailyCheckinReminder) ||
                other.dailyCheckinReminder == dailyCheckinReminder) &&
            (identical(other.checkinReminderTime, checkinReminderTime) ||
                other.checkinReminderTime == checkinReminderTime) &&
            (identical(other.medicationReminders, medicationReminders) ||
                other.medicationReminders == medicationReminders) &&
            (identical(other.cravingAlerts, cravingAlerts) ||
                other.cravingAlerts == cravingAlerts) &&
            (identical(other.weeklyReports, weeklyReports) ||
                other.weeklyReports == weeklyReports) &&
            (identical(other.biometricLock, biometricLock) ||
                other.biometricLock == biometricLock) &&
            (identical(other.requirePinOnOpen, requirePinOnOpen) ||
                other.requirePinOnOpen == requirePinOnOpen) &&
            (identical(other.autoLockDuration, autoLockDuration) ||
                other.autoLockDuration == autoLockDuration) &&
            (identical(other.hideContentInRecents, hideContentInRecents) ||
                other.hideContentInRecents == hideContentInRecents) &&
            (identical(other.analyticsEnabled, analyticsEnabled) ||
                other.analyticsEnabled == analyticsEnabled) &&
            (identical(other.autoBackup, autoBackup) ||
                other.autoBackup == autoBackup) &&
            (identical(other.backupFrequency, backupFrequency) ||
                other.backupFrequency == backupFrequency) &&
            (identical(other.syncEnabled, syncEnabled) ||
                other.syncEnabled == syncEnabled) &&
            (identical(other.offlineMode, offlineMode) ||
                other.offlineMode == offlineMode) &&
            (identical(other.cacheEnabled, cacheEnabled) ||
                other.cacheEnabled == cacheEnabled) &&
            (identical(other.cacheDuration, cacheDuration) ||
                other.cacheDuration == cacheDuration) &&
            (identical(other.defaultDoseUnit, defaultDoseUnit) ||
                other.defaultDoseUnit == defaultDoseUnit) &&
            (identical(other.quickEntryMode, quickEntryMode) ||
                other.quickEntryMode == quickEntryMode) &&
            (identical(other.autoSaveEntries, autoSaveEntries) ||
                other.autoSaveEntries == autoSaveEntries) &&
            (identical(other.showRecentSubstances, showRecentSubstances) ||
                other.showRecentSubstances == showRecentSubstances) &&
            (identical(other.recentSubstancesCount, recentSubstancesCount) ||
                other.recentSubstancesCount == recentSubstancesCount) &&
            (identical(other.show24HourTime, show24HourTime) ||
                other.show24HourTime == show24HourTime) &&
            (identical(other.dateFormat, dateFormat) ||
                other.dateFormat == dateFormat) &&
            (identical(other.showBloodLevels, showBloodLevels) ||
                other.showBloodLevels == showBloodLevels) &&
            (identical(other.showAnalytics, showAnalytics) ||
                other.showAnalytics == showAnalytics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    darkMode,
    fontSize,
    compactMode,
    language,
    notificationsEnabled,
    dailyCheckinReminder,
    checkinReminderTime,
    medicationReminders,
    cravingAlerts,
    weeklyReports,
    biometricLock,
    requirePinOnOpen,
    autoLockDuration,
    hideContentInRecents,
    analyticsEnabled,
    autoBackup,
    backupFrequency,
    syncEnabled,
    offlineMode,
    cacheEnabled,
    cacheDuration,
    defaultDoseUnit,
    quickEntryMode,
    autoSaveEntries,
    showRecentSubstances,
    recentSubstancesCount,
    show24HourTime,
    dateFormat,
    showBloodLevels,
    showAnalytics,
  ]);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final bool darkMode,
    final double fontSize,
    final bool compactMode,
    final String language,
    final bool notificationsEnabled,
    final bool dailyCheckinReminder,
    final String checkinReminderTime,
    final bool medicationReminders,
    final bool cravingAlerts,
    final bool weeklyReports,
    final bool biometricLock,
    final bool requirePinOnOpen,
    final String autoLockDuration,
    final bool hideContentInRecents,
    final bool analyticsEnabled,
    final bool autoBackup,
    final String backupFrequency,
    final bool syncEnabled,
    final bool offlineMode,
    final bool cacheEnabled,
    final String cacheDuration,
    final String defaultDoseUnit,
    final bool quickEntryMode,
    final bool autoSaveEntries,
    final bool showRecentSubstances,
    final int recentSubstancesCount,
    final bool show24HourTime,
    final String dateFormat,
    final bool showBloodLevels,
    final bool showAnalytics,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  // UI Settings
  @override
  bool get darkMode;
  @override
  double get fontSize;
  @override
  bool get compactMode;
  @override
  String get language; // Notification Settings
  @override
  bool get notificationsEnabled;
  @override
  bool get dailyCheckinReminder;
  @override
  String get checkinReminderTime;
  @override
  bool get medicationReminders;
  @override
  bool get cravingAlerts;
  @override
  bool get weeklyReports; // Privacy Settings
  @override
  bool get biometricLock;
  @override
  bool get requirePinOnOpen;
  @override
  String get autoLockDuration; // '1min', '5min', '15min', 'never'
  @override
  bool get hideContentInRecents;
  @override
  bool get analyticsEnabled; // Data Settings
  @override
  bool get autoBackup;
  @override
  String get backupFrequency; // 'daily', 'weekly', 'monthly'
  @override
  bool get syncEnabled;
  @override
  bool get offlineMode;
  @override
  bool get cacheEnabled;
  @override
  String get cacheDuration; // '1hour', '6hours', '1day'
  // Entry Settings
  @override
  String get defaultDoseUnit;
  @override
  bool get quickEntryMode;
  @override
  bool get autoSaveEntries;
  @override
  bool get showRecentSubstances;
  @override
  int get recentSubstancesCount; // Display Settings
  @override
  bool get show24HourTime;
  @override
  String get dateFormat; // 'MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'
  @override
  bool get showBloodLevels;
  @override
  bool get showAnalytics;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
