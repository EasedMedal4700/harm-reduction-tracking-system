// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LogEntryNotifier)
final logEntryProvider = LogEntryNotifierProvider._();

final class LogEntryNotifierProvider
    extends $NotifierProvider<LogEntryNotifier, LogEntryFormData> {
  LogEntryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logEntryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logEntryNotifierHash();

  @$internal
  @override
  LogEntryNotifier create() => LogEntryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogEntryFormData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogEntryFormData>(value),
    );
  }
}

String _$logEntryNotifierHash() => r'17f1b26f0e1e5462ba4d6a6b8b5f259d2149284a';

abstract class _$LogEntryNotifier extends $Notifier<LogEntryFormData> {
  LogEntryFormData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LogEntryFormData, LogEntryFormData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LogEntryFormData, LogEntryFormData>,
              LogEntryFormData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
