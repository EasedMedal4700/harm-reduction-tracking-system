// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Drug provider.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubstanceController extends Notifier<String> {
  @override
  String build() => ''; // initial value
  void setSubstance(String value) {
    state = value;
  }
}

final substanceControllerProvider =
    NotifierProvider<SubstanceController, String>(() => SubstanceController());
