// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry_save_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LogEntrySaveController)
final logEntrySaveControllerProvider = LogEntrySaveControllerProvider._();

final class LogEntrySaveControllerProvider
    extends $NotifierProvider<LogEntrySaveController, LogEntrySaveFlowState> {
  LogEntrySaveControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logEntrySaveControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logEntrySaveControllerHash();

  @$internal
  @override
  LogEntrySaveController create() => LogEntrySaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogEntrySaveFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogEntrySaveFlowState>(value),
    );
  }
}

String _$logEntrySaveControllerHash() =>
    r'bbf0f00cd81f5940a45c33bb01b8c5e2d74c5a0e';

abstract class _$LogEntrySaveController
    extends $Notifier<LogEntrySaveFlowState> {
  LogEntrySaveFlowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LogEntrySaveFlowState, LogEntrySaveFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LogEntrySaveFlowState, LogEntrySaveFlowState>,
              LogEntrySaveFlowState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
