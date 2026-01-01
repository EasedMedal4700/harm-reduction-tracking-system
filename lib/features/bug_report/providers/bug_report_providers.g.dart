// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bug_report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BugReportController)
final bugReportControllerProvider = BugReportControllerProvider._();

final class BugReportControllerProvider
    extends $NotifierProvider<BugReportController, BugReportState> {
  BugReportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bugReportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bugReportControllerHash();

  @$internal
  @override
  BugReportController create() => BugReportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BugReportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BugReportState>(value),
    );
  }
}

String _$bugReportControllerHash() =>
    r'5ff55f681293bbd3242f09d2921be26b4522a9eb';

abstract class _$BugReportController extends $Notifier<BugReportState> {
  BugReportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BugReportState, BugReportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BugReportState, BugReportState>,
              BugReportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
