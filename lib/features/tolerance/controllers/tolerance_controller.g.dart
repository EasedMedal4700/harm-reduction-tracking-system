// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tolerance_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ToleranceController)
final toleranceControllerProvider = ToleranceControllerFamily._();

final class ToleranceControllerProvider
    extends $AsyncNotifierProvider<ToleranceController, ToleranceResult> {
  ToleranceControllerProvider._({
    required ToleranceControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'toleranceControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$toleranceControllerHash();

  @override
  String toString() {
    return r'toleranceControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ToleranceController create() => ToleranceController();

  @override
  bool operator ==(Object other) {
    return other is ToleranceControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$toleranceControllerHash() =>
    r'000529c5c349e12cf2190075f3d94fdfe0761697';

final class ToleranceControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ToleranceController,
          AsyncValue<ToleranceResult>,
          ToleranceResult,
          FutureOr<ToleranceResult>,
          String
        > {
  ToleranceControllerFamily._()
    : super(
        retry: null,
        name: r'toleranceControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ToleranceControllerProvider call(String userId) =>
      ToleranceControllerProvider._(argument: userId, from: this);

  @override
  String toString() => r'toleranceControllerProvider';
}

abstract class _$ToleranceController extends $AsyncNotifier<ToleranceResult> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<ToleranceResult> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ToleranceResult>, ToleranceResult>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ToleranceResult>, ToleranceResult>,
              AsyncValue<ToleranceResult>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
