// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Feature model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_levels_timeline_request.freezed.dart';

@freezed
class BloodLevelsTimelineRequest with _$BloodLevelsTimelineRequest {
  const factory BloodLevelsTimelineRequest({
    required List<String> drugNames,
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
  }) = _BloodLevelsTimelineRequest;
}
