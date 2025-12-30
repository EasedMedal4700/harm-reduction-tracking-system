// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checkin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyCheckinRepositoryHash() =>
    r'82c51ee6b05965caf91256d0c48e60b9852e835d';

/// See also [dailyCheckinRepository].
@ProviderFor(dailyCheckinRepository)
final dailyCheckinRepositoryProvider =
    AutoDisposeProvider<DailyCheckinRepository>.internal(
      dailyCheckinRepository,
      name: r'dailyCheckinRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyCheckinRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyCheckinRepositoryRef =
    AutoDisposeProviderRef<DailyCheckinRepository>;
String _$dailyCheckinForNowHash() =>
    r'0acb38ce5b42a3ae13b3927a141c14176a209703';

/// See also [dailyCheckinForNow].
@ProviderFor(dailyCheckinForNow)
final dailyCheckinForNowProvider =
    AutoDisposeFutureProvider<DailyCheckin?>.internal(
      dailyCheckinForNow,
      name: r'dailyCheckinForNowProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyCheckinForNowHash,
      dependencies: <ProviderOrFamily>[dailyCheckinRepositoryProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        dailyCheckinRepositoryProvider,
        ...?dailyCheckinRepositoryProvider.allTransitiveDependencies,
      },
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyCheckinForNowRef = AutoDisposeFutureProviderRef<DailyCheckin?>;
String _$dailyCheckinControllerHash() =>
    r'858e2419122b8febd088e279aebfcb577bba1baa';

/// See also [DailyCheckinController].
@ProviderFor(DailyCheckinController)
final dailyCheckinControllerProvider =
    AutoDisposeNotifierProvider<
      DailyCheckinController,
      DailyCheckinState
    >.internal(
      DailyCheckinController.new,
      name: r'dailyCheckinControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyCheckinControllerHash,
      dependencies: <ProviderOrFamily>[dailyCheckinRepositoryProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        dailyCheckinRepositoryProvider,
        ...?dailyCheckinRepositoryProvider.allTransitiveDependencies,
      },
    );

typedef _$DailyCheckinController = AutoDisposeNotifier<DailyCheckinState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
