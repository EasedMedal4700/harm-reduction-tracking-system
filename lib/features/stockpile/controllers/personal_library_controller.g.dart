// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_library_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PersonalLibraryController)
final personalLibraryControllerProvider = PersonalLibraryControllerProvider._();

final class PersonalLibraryControllerProvider
    extends
        $AsyncNotifierProvider<
          PersonalLibraryController,
          PersonalLibraryState
        > {
  PersonalLibraryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalLibraryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalLibraryControllerHash();

  @$internal
  @override
  PersonalLibraryController create() => PersonalLibraryController();
}

String _$personalLibraryControllerHash() =>
    r'86ab83b4de025e7adb2ed06e0c345d9eba1c0cb0';

abstract class _$PersonalLibraryController
    extends $AsyncNotifier<PersonalLibraryState> {
  FutureOr<PersonalLibraryState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PersonalLibraryState>, PersonalLibraryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PersonalLibraryState>,
                PersonalLibraryState
              >,
              AsyncValue<PersonalLibraryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
