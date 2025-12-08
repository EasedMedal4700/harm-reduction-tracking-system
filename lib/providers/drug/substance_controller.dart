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
