// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Immutable label+count tuple used in analytics breakdowns.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'label_count.freezed.dart';

@freezed
class LabelCount with _$LabelCount {
  const factory LabelCount({required String label, @Default(0) int count}) =
      _LabelCount;
}
