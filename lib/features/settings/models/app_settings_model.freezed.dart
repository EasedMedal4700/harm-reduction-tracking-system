// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

// UI Settings
 bool get darkMode; double get fontSize; bool get compactMode; String get language;// Notification Settings
 bool get notificationsEnabled; bool get dailyCheckinReminder; String get checkinReminderTime; bool get medicationReminders; bool get cravingAlerts; bool get weeklyReports;// Privacy Settings
 bool get biometricLock; bool get requirePinOnOpen; String get autoLockDuration;// '1min', '5min', '15min', 'never'
 bool get hideContentInRecents; bool get analyticsEnabled;// Data Settings
 bool get autoBackup; String get backupFrequency;// 'daily', 'weekly', 'monthly'
 bool get syncEnabled; bool get offlineMode; bool get cacheEnabled; String get cacheDuration;// '1hour', '6hours', '1day'
// Entry Settings
 String get defaultDoseUnit; bool get quickEntryMode; bool get autoSaveEntries; bool get showRecentSubstances; int get recentSubstancesCount;// Display Settings
 bool get show24HourTime; String get dateFormat;// 'MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'
 bool get showBloodLevels; bool get showAnalytics;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.compactMode, compactMode) || other.compactMode == compactMode)&&(identical(other.language, language) || other.language == language)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyCheckinReminder, dailyCheckinReminder) || other.dailyCheckinReminder == dailyCheckinReminder)&&(identical(other.checkinReminderTime, checkinReminderTime) || other.checkinReminderTime == checkinReminderTime)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.cravingAlerts, cravingAlerts) || other.cravingAlerts == cravingAlerts)&&(identical(other.weeklyReports, weeklyReports) || other.weeklyReports == weeklyReports)&&(identical(other.biometricLock, biometricLock) || other.biometricLock == biometricLock)&&(identical(other.requirePinOnOpen, requirePinOnOpen) || other.requirePinOnOpen == requirePinOnOpen)&&(identical(other.autoLockDuration, autoLockDuration) || other.autoLockDuration == autoLockDuration)&&(identical(other.hideContentInRecents, hideContentInRecents) || other.hideContentInRecents == hideContentInRecents)&&(identical(other.analyticsEnabled, analyticsEnabled) || other.analyticsEnabled == analyticsEnabled)&&(identical(other.autoBackup, autoBackup) || other.autoBackup == autoBackup)&&(identical(other.backupFrequency, backupFrequency) || other.backupFrequency == backupFrequency)&&(identical(other.syncEnabled, syncEnabled) || other.syncEnabled == syncEnabled)&&(identical(other.offlineMode, offlineMode) || other.offlineMode == offlineMode)&&(identical(other.cacheEnabled, cacheEnabled) || other.cacheEnabled == cacheEnabled)&&(identical(other.cacheDuration, cacheDuration) || other.cacheDuration == cacheDuration)&&(identical(other.defaultDoseUnit, defaultDoseUnit) || other.defaultDoseUnit == defaultDoseUnit)&&(identical(other.quickEntryMode, quickEntryMode) || other.quickEntryMode == quickEntryMode)&&(identical(other.autoSaveEntries, autoSaveEntries) || other.autoSaveEntries == autoSaveEntries)&&(identical(other.showRecentSubstances, showRecentSubstances) || other.showRecentSubstances == showRecentSubstances)&&(identical(other.recentSubstancesCount, recentSubstancesCount) || other.recentSubstancesCount == recentSubstancesCount)&&(identical(other.show24HourTime, show24HourTime) || other.show24HourTime == show24HourTime)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.showBloodLevels, showBloodLevels) || other.showBloodLevels == showBloodLevels)&&(identical(other.showAnalytics, showAnalytics) || other.showAnalytics == showAnalytics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,darkMode,fontSize,compactMode,language,notificationsEnabled,dailyCheckinReminder,checkinReminderTime,medicationReminders,cravingAlerts,weeklyReports,biometricLock,requirePinOnOpen,autoLockDuration,hideContentInRecents,analyticsEnabled,autoBackup,backupFrequency,syncEnabled,offlineMode,cacheEnabled,cacheDuration,defaultDoseUnit,quickEntryMode,autoSaveEntries,showRecentSubstances,recentSubstancesCount,show24HourTime,dateFormat,showBloodLevels,showAnalytics]);

@override
String toString() {
  return 'AppSettings(darkMode: $darkMode, fontSize: $fontSize, compactMode: $compactMode, language: $language, notificationsEnabled: $notificationsEnabled, dailyCheckinReminder: $dailyCheckinReminder, checkinReminderTime: $checkinReminderTime, medicationReminders: $medicationReminders, cravingAlerts: $cravingAlerts, weeklyReports: $weeklyReports, biometricLock: $biometricLock, requirePinOnOpen: $requirePinOnOpen, autoLockDuration: $autoLockDuration, hideContentInRecents: $hideContentInRecents, analyticsEnabled: $analyticsEnabled, autoBackup: $autoBackup, backupFrequency: $backupFrequency, syncEnabled: $syncEnabled, offlineMode: $offlineMode, cacheEnabled: $cacheEnabled, cacheDuration: $cacheDuration, defaultDoseUnit: $defaultDoseUnit, quickEntryMode: $quickEntryMode, autoSaveEntries: $autoSaveEntries, showRecentSubstances: $showRecentSubstances, recentSubstancesCount: $recentSubstancesCount, show24HourTime: $show24HourTime, dateFormat: $dateFormat, showBloodLevels: $showBloodLevels, showAnalytics: $showAnalytics)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 bool darkMode, double fontSize, bool compactMode, String language, bool notificationsEnabled, bool dailyCheckinReminder, String checkinReminderTime, bool medicationReminders, bool cravingAlerts, bool weeklyReports, bool biometricLock, bool requirePinOnOpen, String autoLockDuration, bool hideContentInRecents, bool analyticsEnabled, bool autoBackup, String backupFrequency, bool syncEnabled, bool offlineMode, bool cacheEnabled, String cacheDuration, String defaultDoseUnit, bool quickEntryMode, bool autoSaveEntries, bool showRecentSubstances, int recentSubstancesCount, bool show24HourTime, String dateFormat, bool showBloodLevels, bool showAnalytics
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? darkMode = null,Object? fontSize = null,Object? compactMode = null,Object? language = null,Object? notificationsEnabled = null,Object? dailyCheckinReminder = null,Object? checkinReminderTime = null,Object? medicationReminders = null,Object? cravingAlerts = null,Object? weeklyReports = null,Object? biometricLock = null,Object? requirePinOnOpen = null,Object? autoLockDuration = null,Object? hideContentInRecents = null,Object? analyticsEnabled = null,Object? autoBackup = null,Object? backupFrequency = null,Object? syncEnabled = null,Object? offlineMode = null,Object? cacheEnabled = null,Object? cacheDuration = null,Object? defaultDoseUnit = null,Object? quickEntryMode = null,Object? autoSaveEntries = null,Object? showRecentSubstances = null,Object? recentSubstancesCount = null,Object? show24HourTime = null,Object? dateFormat = null,Object? showBloodLevels = null,Object? showAnalytics = null,}) {
  return _then(_self.copyWith(
darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,compactMode: null == compactMode ? _self.compactMode : compactMode // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyCheckinReminder: null == dailyCheckinReminder ? _self.dailyCheckinReminder : dailyCheckinReminder // ignore: cast_nullable_to_non_nullable
as bool,checkinReminderTime: null == checkinReminderTime ? _self.checkinReminderTime : checkinReminderTime // ignore: cast_nullable_to_non_nullable
as String,medicationReminders: null == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool,cravingAlerts: null == cravingAlerts ? _self.cravingAlerts : cravingAlerts // ignore: cast_nullable_to_non_nullable
as bool,weeklyReports: null == weeklyReports ? _self.weeklyReports : weeklyReports // ignore: cast_nullable_to_non_nullable
as bool,biometricLock: null == biometricLock ? _self.biometricLock : biometricLock // ignore: cast_nullable_to_non_nullable
as bool,requirePinOnOpen: null == requirePinOnOpen ? _self.requirePinOnOpen : requirePinOnOpen // ignore: cast_nullable_to_non_nullable
as bool,autoLockDuration: null == autoLockDuration ? _self.autoLockDuration : autoLockDuration // ignore: cast_nullable_to_non_nullable
as String,hideContentInRecents: null == hideContentInRecents ? _self.hideContentInRecents : hideContentInRecents // ignore: cast_nullable_to_non_nullable
as bool,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoBackup: null == autoBackup ? _self.autoBackup : autoBackup // ignore: cast_nullable_to_non_nullable
as bool,backupFrequency: null == backupFrequency ? _self.backupFrequency : backupFrequency // ignore: cast_nullable_to_non_nullable
as String,syncEnabled: null == syncEnabled ? _self.syncEnabled : syncEnabled // ignore: cast_nullable_to_non_nullable
as bool,offlineMode: null == offlineMode ? _self.offlineMode : offlineMode // ignore: cast_nullable_to_non_nullable
as bool,cacheEnabled: null == cacheEnabled ? _self.cacheEnabled : cacheEnabled // ignore: cast_nullable_to_non_nullable
as bool,cacheDuration: null == cacheDuration ? _self.cacheDuration : cacheDuration // ignore: cast_nullable_to_non_nullable
as String,defaultDoseUnit: null == defaultDoseUnit ? _self.defaultDoseUnit : defaultDoseUnit // ignore: cast_nullable_to_non_nullable
as String,quickEntryMode: null == quickEntryMode ? _self.quickEntryMode : quickEntryMode // ignore: cast_nullable_to_non_nullable
as bool,autoSaveEntries: null == autoSaveEntries ? _self.autoSaveEntries : autoSaveEntries // ignore: cast_nullable_to_non_nullable
as bool,showRecentSubstances: null == showRecentSubstances ? _self.showRecentSubstances : showRecentSubstances // ignore: cast_nullable_to_non_nullable
as bool,recentSubstancesCount: null == recentSubstancesCount ? _self.recentSubstancesCount : recentSubstancesCount // ignore: cast_nullable_to_non_nullable
as int,show24HourTime: null == show24HourTime ? _self.show24HourTime : show24HourTime // ignore: cast_nullable_to_non_nullable
as bool,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,showBloodLevels: null == showBloodLevels ? _self.showBloodLevels : showBloodLevels // ignore: cast_nullable_to_non_nullable
as bool,showAnalytics: null == showAnalytics ? _self.showAnalytics : showAnalytics // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool darkMode,  double fontSize,  bool compactMode,  String language,  bool notificationsEnabled,  bool dailyCheckinReminder,  String checkinReminderTime,  bool medicationReminders,  bool cravingAlerts,  bool weeklyReports,  bool biometricLock,  bool requirePinOnOpen,  String autoLockDuration,  bool hideContentInRecents,  bool analyticsEnabled,  bool autoBackup,  String backupFrequency,  bool syncEnabled,  bool offlineMode,  bool cacheEnabled,  String cacheDuration,  String defaultDoseUnit,  bool quickEntryMode,  bool autoSaveEntries,  bool showRecentSubstances,  int recentSubstancesCount,  bool show24HourTime,  String dateFormat,  bool showBloodLevels,  bool showAnalytics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.darkMode,_that.fontSize,_that.compactMode,_that.language,_that.notificationsEnabled,_that.dailyCheckinReminder,_that.checkinReminderTime,_that.medicationReminders,_that.cravingAlerts,_that.weeklyReports,_that.biometricLock,_that.requirePinOnOpen,_that.autoLockDuration,_that.hideContentInRecents,_that.analyticsEnabled,_that.autoBackup,_that.backupFrequency,_that.syncEnabled,_that.offlineMode,_that.cacheEnabled,_that.cacheDuration,_that.defaultDoseUnit,_that.quickEntryMode,_that.autoSaveEntries,_that.showRecentSubstances,_that.recentSubstancesCount,_that.show24HourTime,_that.dateFormat,_that.showBloodLevels,_that.showAnalytics);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool darkMode,  double fontSize,  bool compactMode,  String language,  bool notificationsEnabled,  bool dailyCheckinReminder,  String checkinReminderTime,  bool medicationReminders,  bool cravingAlerts,  bool weeklyReports,  bool biometricLock,  bool requirePinOnOpen,  String autoLockDuration,  bool hideContentInRecents,  bool analyticsEnabled,  bool autoBackup,  String backupFrequency,  bool syncEnabled,  bool offlineMode,  bool cacheEnabled,  String cacheDuration,  String defaultDoseUnit,  bool quickEntryMode,  bool autoSaveEntries,  bool showRecentSubstances,  int recentSubstancesCount,  bool show24HourTime,  String dateFormat,  bool showBloodLevels,  bool showAnalytics)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.darkMode,_that.fontSize,_that.compactMode,_that.language,_that.notificationsEnabled,_that.dailyCheckinReminder,_that.checkinReminderTime,_that.medicationReminders,_that.cravingAlerts,_that.weeklyReports,_that.biometricLock,_that.requirePinOnOpen,_that.autoLockDuration,_that.hideContentInRecents,_that.analyticsEnabled,_that.autoBackup,_that.backupFrequency,_that.syncEnabled,_that.offlineMode,_that.cacheEnabled,_that.cacheDuration,_that.defaultDoseUnit,_that.quickEntryMode,_that.autoSaveEntries,_that.showRecentSubstances,_that.recentSubstancesCount,_that.show24HourTime,_that.dateFormat,_that.showBloodLevels,_that.showAnalytics);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool darkMode,  double fontSize,  bool compactMode,  String language,  bool notificationsEnabled,  bool dailyCheckinReminder,  String checkinReminderTime,  bool medicationReminders,  bool cravingAlerts,  bool weeklyReports,  bool biometricLock,  bool requirePinOnOpen,  String autoLockDuration,  bool hideContentInRecents,  bool analyticsEnabled,  bool autoBackup,  String backupFrequency,  bool syncEnabled,  bool offlineMode,  bool cacheEnabled,  String cacheDuration,  String defaultDoseUnit,  bool quickEntryMode,  bool autoSaveEntries,  bool showRecentSubstances,  int recentSubstancesCount,  bool show24HourTime,  String dateFormat,  bool showBloodLevels,  bool showAnalytics)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.darkMode,_that.fontSize,_that.compactMode,_that.language,_that.notificationsEnabled,_that.dailyCheckinReminder,_that.checkinReminderTime,_that.medicationReminders,_that.cravingAlerts,_that.weeklyReports,_that.biometricLock,_that.requirePinOnOpen,_that.autoLockDuration,_that.hideContentInRecents,_that.analyticsEnabled,_that.autoBackup,_that.backupFrequency,_that.syncEnabled,_that.offlineMode,_that.cacheEnabled,_that.cacheDuration,_that.defaultDoseUnit,_that.quickEntryMode,_that.autoSaveEntries,_that.showRecentSubstances,_that.recentSubstancesCount,_that.show24HourTime,_that.dateFormat,_that.showBloodLevels,_that.showAnalytics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({this.darkMode = false, this.fontSize = 14.0, this.compactMode = false, this.language = 'en', this.notificationsEnabled = true, this.dailyCheckinReminder = true, this.checkinReminderTime = '09:00', this.medicationReminders = true, this.cravingAlerts = true, this.weeklyReports = false, this.biometricLock = false, this.requirePinOnOpen = false, this.autoLockDuration = '5min', this.hideContentInRecents = false, this.analyticsEnabled = false, this.autoBackup = false, this.backupFrequency = 'weekly', this.syncEnabled = true, this.offlineMode = false, this.cacheEnabled = true, this.cacheDuration = '1hour', this.defaultDoseUnit = 'mg', this.quickEntryMode = false, this.autoSaveEntries = true, this.showRecentSubstances = true, this.recentSubstancesCount = 5, this.show24HourTime = false, this.dateFormat = 'MM/DD/YYYY', this.showBloodLevels = true, this.showAnalytics = true});
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

// UI Settings
@override@JsonKey() final  bool darkMode;
@override@JsonKey() final  double fontSize;
@override@JsonKey() final  bool compactMode;
@override@JsonKey() final  String language;
// Notification Settings
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool dailyCheckinReminder;
@override@JsonKey() final  String checkinReminderTime;
@override@JsonKey() final  bool medicationReminders;
@override@JsonKey() final  bool cravingAlerts;
@override@JsonKey() final  bool weeklyReports;
// Privacy Settings
@override@JsonKey() final  bool biometricLock;
@override@JsonKey() final  bool requirePinOnOpen;
@override@JsonKey() final  String autoLockDuration;
// '1min', '5min', '15min', 'never'
@override@JsonKey() final  bool hideContentInRecents;
@override@JsonKey() final  bool analyticsEnabled;
// Data Settings
@override@JsonKey() final  bool autoBackup;
@override@JsonKey() final  String backupFrequency;
// 'daily', 'weekly', 'monthly'
@override@JsonKey() final  bool syncEnabled;
@override@JsonKey() final  bool offlineMode;
@override@JsonKey() final  bool cacheEnabled;
@override@JsonKey() final  String cacheDuration;
// '1hour', '6hours', '1day'
// Entry Settings
@override@JsonKey() final  String defaultDoseUnit;
@override@JsonKey() final  bool quickEntryMode;
@override@JsonKey() final  bool autoSaveEntries;
@override@JsonKey() final  bool showRecentSubstances;
@override@JsonKey() final  int recentSubstancesCount;
// Display Settings
@override@JsonKey() final  bool show24HourTime;
@override@JsonKey() final  String dateFormat;
// 'MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'
@override@JsonKey() final  bool showBloodLevels;
@override@JsonKey() final  bool showAnalytics;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.compactMode, compactMode) || other.compactMode == compactMode)&&(identical(other.language, language) || other.language == language)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyCheckinReminder, dailyCheckinReminder) || other.dailyCheckinReminder == dailyCheckinReminder)&&(identical(other.checkinReminderTime, checkinReminderTime) || other.checkinReminderTime == checkinReminderTime)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.cravingAlerts, cravingAlerts) || other.cravingAlerts == cravingAlerts)&&(identical(other.weeklyReports, weeklyReports) || other.weeklyReports == weeklyReports)&&(identical(other.biometricLock, biometricLock) || other.biometricLock == biometricLock)&&(identical(other.requirePinOnOpen, requirePinOnOpen) || other.requirePinOnOpen == requirePinOnOpen)&&(identical(other.autoLockDuration, autoLockDuration) || other.autoLockDuration == autoLockDuration)&&(identical(other.hideContentInRecents, hideContentInRecents) || other.hideContentInRecents == hideContentInRecents)&&(identical(other.analyticsEnabled, analyticsEnabled) || other.analyticsEnabled == analyticsEnabled)&&(identical(other.autoBackup, autoBackup) || other.autoBackup == autoBackup)&&(identical(other.backupFrequency, backupFrequency) || other.backupFrequency == backupFrequency)&&(identical(other.syncEnabled, syncEnabled) || other.syncEnabled == syncEnabled)&&(identical(other.offlineMode, offlineMode) || other.offlineMode == offlineMode)&&(identical(other.cacheEnabled, cacheEnabled) || other.cacheEnabled == cacheEnabled)&&(identical(other.cacheDuration, cacheDuration) || other.cacheDuration == cacheDuration)&&(identical(other.defaultDoseUnit, defaultDoseUnit) || other.defaultDoseUnit == defaultDoseUnit)&&(identical(other.quickEntryMode, quickEntryMode) || other.quickEntryMode == quickEntryMode)&&(identical(other.autoSaveEntries, autoSaveEntries) || other.autoSaveEntries == autoSaveEntries)&&(identical(other.showRecentSubstances, showRecentSubstances) || other.showRecentSubstances == showRecentSubstances)&&(identical(other.recentSubstancesCount, recentSubstancesCount) || other.recentSubstancesCount == recentSubstancesCount)&&(identical(other.show24HourTime, show24HourTime) || other.show24HourTime == show24HourTime)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.showBloodLevels, showBloodLevels) || other.showBloodLevels == showBloodLevels)&&(identical(other.showAnalytics, showAnalytics) || other.showAnalytics == showAnalytics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,darkMode,fontSize,compactMode,language,notificationsEnabled,dailyCheckinReminder,checkinReminderTime,medicationReminders,cravingAlerts,weeklyReports,biometricLock,requirePinOnOpen,autoLockDuration,hideContentInRecents,analyticsEnabled,autoBackup,backupFrequency,syncEnabled,offlineMode,cacheEnabled,cacheDuration,defaultDoseUnit,quickEntryMode,autoSaveEntries,showRecentSubstances,recentSubstancesCount,show24HourTime,dateFormat,showBloodLevels,showAnalytics]);

@override
String toString() {
  return 'AppSettings(darkMode: $darkMode, fontSize: $fontSize, compactMode: $compactMode, language: $language, notificationsEnabled: $notificationsEnabled, dailyCheckinReminder: $dailyCheckinReminder, checkinReminderTime: $checkinReminderTime, medicationReminders: $medicationReminders, cravingAlerts: $cravingAlerts, weeklyReports: $weeklyReports, biometricLock: $biometricLock, requirePinOnOpen: $requirePinOnOpen, autoLockDuration: $autoLockDuration, hideContentInRecents: $hideContentInRecents, analyticsEnabled: $analyticsEnabled, autoBackup: $autoBackup, backupFrequency: $backupFrequency, syncEnabled: $syncEnabled, offlineMode: $offlineMode, cacheEnabled: $cacheEnabled, cacheDuration: $cacheDuration, defaultDoseUnit: $defaultDoseUnit, quickEntryMode: $quickEntryMode, autoSaveEntries: $autoSaveEntries, showRecentSubstances: $showRecentSubstances, recentSubstancesCount: $recentSubstancesCount, show24HourTime: $show24HourTime, dateFormat: $dateFormat, showBloodLevels: $showBloodLevels, showAnalytics: $showAnalytics)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool darkMode, double fontSize, bool compactMode, String language, bool notificationsEnabled, bool dailyCheckinReminder, String checkinReminderTime, bool medicationReminders, bool cravingAlerts, bool weeklyReports, bool biometricLock, bool requirePinOnOpen, String autoLockDuration, bool hideContentInRecents, bool analyticsEnabled, bool autoBackup, String backupFrequency, bool syncEnabled, bool offlineMode, bool cacheEnabled, String cacheDuration, String defaultDoseUnit, bool quickEntryMode, bool autoSaveEntries, bool showRecentSubstances, int recentSubstancesCount, bool show24HourTime, String dateFormat, bool showBloodLevels, bool showAnalytics
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? darkMode = null,Object? fontSize = null,Object? compactMode = null,Object? language = null,Object? notificationsEnabled = null,Object? dailyCheckinReminder = null,Object? checkinReminderTime = null,Object? medicationReminders = null,Object? cravingAlerts = null,Object? weeklyReports = null,Object? biometricLock = null,Object? requirePinOnOpen = null,Object? autoLockDuration = null,Object? hideContentInRecents = null,Object? analyticsEnabled = null,Object? autoBackup = null,Object? backupFrequency = null,Object? syncEnabled = null,Object? offlineMode = null,Object? cacheEnabled = null,Object? cacheDuration = null,Object? defaultDoseUnit = null,Object? quickEntryMode = null,Object? autoSaveEntries = null,Object? showRecentSubstances = null,Object? recentSubstancesCount = null,Object? show24HourTime = null,Object? dateFormat = null,Object? showBloodLevels = null,Object? showAnalytics = null,}) {
  return _then(_AppSettings(
darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,compactMode: null == compactMode ? _self.compactMode : compactMode // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyCheckinReminder: null == dailyCheckinReminder ? _self.dailyCheckinReminder : dailyCheckinReminder // ignore: cast_nullable_to_non_nullable
as bool,checkinReminderTime: null == checkinReminderTime ? _self.checkinReminderTime : checkinReminderTime // ignore: cast_nullable_to_non_nullable
as String,medicationReminders: null == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool,cravingAlerts: null == cravingAlerts ? _self.cravingAlerts : cravingAlerts // ignore: cast_nullable_to_non_nullable
as bool,weeklyReports: null == weeklyReports ? _self.weeklyReports : weeklyReports // ignore: cast_nullable_to_non_nullable
as bool,biometricLock: null == biometricLock ? _self.biometricLock : biometricLock // ignore: cast_nullable_to_non_nullable
as bool,requirePinOnOpen: null == requirePinOnOpen ? _self.requirePinOnOpen : requirePinOnOpen // ignore: cast_nullable_to_non_nullable
as bool,autoLockDuration: null == autoLockDuration ? _self.autoLockDuration : autoLockDuration // ignore: cast_nullable_to_non_nullable
as String,hideContentInRecents: null == hideContentInRecents ? _self.hideContentInRecents : hideContentInRecents // ignore: cast_nullable_to_non_nullable
as bool,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoBackup: null == autoBackup ? _self.autoBackup : autoBackup // ignore: cast_nullable_to_non_nullable
as bool,backupFrequency: null == backupFrequency ? _self.backupFrequency : backupFrequency // ignore: cast_nullable_to_non_nullable
as String,syncEnabled: null == syncEnabled ? _self.syncEnabled : syncEnabled // ignore: cast_nullable_to_non_nullable
as bool,offlineMode: null == offlineMode ? _self.offlineMode : offlineMode // ignore: cast_nullable_to_non_nullable
as bool,cacheEnabled: null == cacheEnabled ? _self.cacheEnabled : cacheEnabled // ignore: cast_nullable_to_non_nullable
as bool,cacheDuration: null == cacheDuration ? _self.cacheDuration : cacheDuration // ignore: cast_nullable_to_non_nullable
as String,defaultDoseUnit: null == defaultDoseUnit ? _self.defaultDoseUnit : defaultDoseUnit // ignore: cast_nullable_to_non_nullable
as String,quickEntryMode: null == quickEntryMode ? _self.quickEntryMode : quickEntryMode // ignore: cast_nullable_to_non_nullable
as bool,autoSaveEntries: null == autoSaveEntries ? _self.autoSaveEntries : autoSaveEntries // ignore: cast_nullable_to_non_nullable
as bool,showRecentSubstances: null == showRecentSubstances ? _self.showRecentSubstances : showRecentSubstances // ignore: cast_nullable_to_non_nullable
as bool,recentSubstancesCount: null == recentSubstancesCount ? _self.recentSubstancesCount : recentSubstancesCount // ignore: cast_nullable_to_non_nullable
as int,show24HourTime: null == show24HourTime ? _self.show24HourTime : show24HourTime // ignore: cast_nullable_to_non_nullable
as bool,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,showBloodLevels: null == showBloodLevels ? _self.showBloodLevels : showBloodLevels // ignore: cast_nullable_to_non_nullable
as bool,showAnalytics: null == showAnalytics ? _self.showAnalytics : showAnalytics // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
