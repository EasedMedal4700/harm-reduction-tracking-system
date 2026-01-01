// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tolerance_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(toleranceRepository)
final toleranceRepositoryProvider = ToleranceRepositoryProvider._();

final class ToleranceRepositoryProvider
    extends
        $FunctionalProvider<
          ToleranceRepository,
          ToleranceRepository,
          ToleranceRepository
        >
    with $Provider<ToleranceRepository> {
  ToleranceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toleranceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toleranceRepositoryHash();

  @$internal
  @override
  $ProviderElement<ToleranceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ToleranceRepository create(Ref ref) {
    return toleranceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToleranceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToleranceRepository>(value),
    );
  }
}

String _$toleranceRepositoryHash() =>
    r'1713c76e8e5565f607e238a67dca44fbde28c257';
