import 'package:flutter/material.dart';
import '../../constants/data/body_and_mind_catalog.dart';
import '../../common/buttons/common_chip_group.dart';

class BodySignalsCard extends StatelessWidget {
  final List<String> selectedBodySignals;
  final ValueChanged<List<String>> onBodySignalsChanged;

  const BodySignalsCard({
    super.key,
    required this.selectedBodySignals,
    required this.onBodySignalsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CommonChipGroup(
      title: "Body Signals",
      subtitle: "Physical sensations you experienced",
      options: physicalSensations,
      selected: selectedBodySignals,
      onChanged: onBodySignalsChanged,
      allowMultiple: true,
      showGlow: true,
    );
  }
}
