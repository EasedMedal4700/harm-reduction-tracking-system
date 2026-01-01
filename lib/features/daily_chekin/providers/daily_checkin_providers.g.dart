// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checkin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyCheckinRepository)
final dailyCheckinRepositoryProvider = DailyCheckinRepositoryProvider._();

final class DailyCheckinRepositoryProvider
    extends
        $FunctionalProvider<
          DailyCheckinRepository,
          DailyCheckinRepository,
          DailyCheckinRepository
        >
    with $Provider<DailyCheckinRepository> {
  DailyCheckinRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyCheckinRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyCheckinRepositoryHash();

  @$internal
  @override
  $ProviderElement<DailyCheckinRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyCheckinRepository create(Ref ref) {
    return dailyCheckinRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyCheckinRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyCheckinRepository>(value),
    );
  }
}

String _$dailyCheckinRepositoryHash() =>
    r'82c51ee6b05965caf91256d0c48e60b9852e835d';

@ProviderFor(dailyCheckinForNow)
final dailyCheckinForNowProvider = DailyCheckinForNowProvider._();

final class DailyCheckinForNowProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyCheckin?>,
          DailyCheckin?,
          FutureOr<DailyCheckin?>
        >
    with $FutureModifier<DailyCheckin?>, $FutureProvider<DailyCheckin?> {
  DailyCheckinForNowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyCheckinForNowProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[dailyCheckinRepositoryProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DailyCheckinForNowProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = dailyCheckinRepositoryProvider;

  @override
  String debugGetCreateSourceHash() => _$dailyCheckinForNowHash();

  @$internal
  @override
  $FutureProviderElement<DailyCheckin?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DailyCheckin?> create(Ref ref) {
    return dailyCheckinForNow(ref);
  }
}

String _$dailyCheckinForNowHash() =>
    r'0acb38ce5b42a3ae13b3927a141c14176a209703';

@ProviderFor(DailyCheckinController)
final dailyCheckinControllerProvider = DailyCheckinControllerProvider._();

final class DailyCheckinControllerProvider
    extends $NotifierProvider<DailyCheckinController, DailyCheckinState> {
  DailyCheckinControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyCheckinControllerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[dailyCheckinRepositoryProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DailyCheckinControllerProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = dailyCheckinRepositoryProvider;

  @override
  String debugGetCreateSourceHash() => _$dailyCheckinControllerHash();

  @$internal
  @override
  DailyCheckinController create() => DailyCheckinController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyCheckinState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyCheckinState>(value),
    );
  }
}

String _$dailyCheckinControllerHash() =>
    r'858e2419122b8febd088e279aebfcb577bba1baa';

abstract class _$DailyCheckinController extends $Notifier<DailyCheckinState> {
  DailyCheckinState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DailyCheckinState, DailyCheckinState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DailyCheckinState, DailyCheckinState>,
              DailyCheckinState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
