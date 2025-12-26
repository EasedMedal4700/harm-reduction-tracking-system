// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Riverpod providers/controllers for admin feature.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/cache_service.dart';
import '../../../services/performance_service.dart';
import '../../../utils/error_reporter.dart';
import '../models/admin_cache_stats.dart';
import '../models/admin_panel_state.dart';
import '../models/admin_performance_stats.dart';
import '../models/error_analytics_state.dart';
import '../services/admin_service.dart';

part 'admin_providers.g.dart';

@riverpod
AdminService adminService(Ref ref) {
  return AdminService();
}

@riverpod
CacheService adminCacheService(Ref ref) {
  return CacheService();
}

@riverpod
class AdminPanelController extends _$AdminPanelController {
  @override
  AdminPanelState build() {
    Future.microtask(_load);
    return const AdminPanelState();
  }

  Future<void> refresh() => _load();

  Future<void> toggleAdmin({
    required String authUserId,
    required bool currentlyAdmin,
  }) async {
    final service = ref.read(adminServiceProvider);
    if (currentlyAdmin) {
      await service.demoteUser(authUserId);
    } else {
      await service.promoteUser(authUserId);
    }
    await _load();
  }

  Future<void> clearAllCache() async {
    final cache = ref.read(adminCacheServiceProvider);
    cache.clearAll();
    await _loadCacheAndPerfOnly();
  }

  Future<void> clearDrugCache() async {
    CacheKeys.clearDrugCache();
    await _loadCacheAndPerfOnly();
  }

  Future<void> clearExpiredCache() async {
    final cache = ref.read(adminCacheServiceProvider);
    cache.clearExpired();
    await _loadCacheAndPerfOnly();
  }

  Future<void> refreshFromDatabase() async {
    final cache = ref.read(adminCacheServiceProvider);
    cache.removePattern('drug_profiles');
    cache.removePattern('drug_use');
    await _loadCacheAndPerfOnly();
  }

  Future<void> _seedPerformanceIfEmpty() async {
    final stats = await PerformanceService.getStatistics();
    if ((stats['total_samples'] as int?) == 0) {
      await PerformanceService.recordResponseTime(
        endpoint: 'initialization',
        milliseconds: 0,
        fromCache: false,
      );
      await PerformanceService.recordCacheEvent(key: 'init', hit: true);
      await PerformanceService.recordCacheEvent(key: 'init2', hit: true);
      await PerformanceService.recordCacheEvent(key: 'init3', hit: false);
    }
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final reporter = ErrorReporter.instance;
    try {
      await _seedPerformanceIfEmpty();
      final service = ref.read(adminServiceProvider);
      final cache = ref.read(adminCacheServiceProvider);

      final users = await service.fetchAllUsers();
      final systemStats = await service.getSystemStats();
      final cacheStats = AdminCacheStats.fromCacheServiceMap(cache.getStats());
      final perfStats = AdminPerformanceStats.fromServiceMap(
        await PerformanceService.getStatistics(),
      );

      state = state.copyWith(
        isLoading: false,
        users: users,
        systemStats: systemStats,
        cacheStats: cacheStats,
        performanceStats: perfStats,
      );
    } catch (e, stackTrace) {
      await reporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'AdminPanelScreen',
        extraData: {'context': 'load_data'},
      );
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> _loadCacheAndPerfOnly() async {
    final cache = ref.read(adminCacheServiceProvider);
    final cacheStats = AdminCacheStats.fromCacheServiceMap(cache.getStats());
    final perfStats = AdminPerformanceStats.fromServiceMap(
      await PerformanceService.getStatistics(),
    );
    state = state.copyWith(cacheStats: cacheStats, performanceStats: perfStats);
  }
}

@riverpod
class ErrorAnalyticsController extends _$ErrorAnalyticsController {
  @override
  ErrorAnalyticsState build() {
    Future.microtask(_load);
    return const ErrorAnalyticsState();
  }

  Future<void> refresh() => _load();

  Future<void> clearErrorLogs({
    required bool deleteAll,
    int? olderThanDays,
    String? platform,
    String? screenName,
  }) async {
    final reporter = ErrorReporter.instance;
    state = state.copyWith(isClearingErrors: true, errorMessage: null);
    try {
      final service = ref.read(adminServiceProvider);
      await service.clearErrorLogs(
        deleteAll: deleteAll,
        olderThanDays: olderThanDays,
        platform: platform,
        screenName: screenName,
      );
      await _load();
    } catch (e, stackTrace) {
      await reporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'ErrorAnalyticsScreen',
        extraData: {'context': 'clear_error_logs'},
      );
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isClearingErrors: false);
    }
  }

  Future<void> _load() async {
    final reporter = ErrorReporter.instance;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final service = ref.read(adminServiceProvider);
      final analytics = await service.getErrorAnalytics();
      state = state.copyWith(isLoading: false, analytics: analytics);
    } catch (e, stackTrace) {
      await reporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'ErrorAnalyticsScreen',
        extraData: {'context': 'load_data'},
      );
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
