import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/inputs/dropdown.dart';
import '../../common/layout/common_spacer.dart';
import '../../constants/data/drug_use_catalog.dart';
import '../../constants/deprecated/theme_constants.dart';

class LocationCard extends StatelessWidget {
  final String location;
  final ValueChanged<String> onLocationChanged;

  const LocationCard({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cleanedLocations = DrugUseCatalog.locations
        .where((loc) => loc.trim().isNotEmpty && loc != 'Select a location')
        .toList();

    final selectedValue = cleanedLocations.contains(location)
        ? location
        : cleanedLocations.first;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Location",
            subtitle: "Where were you during use?",
          ),

          const CommonSpacer.vertical(ThemeConstants.space12),

          CommonDropdown<String>(
            value: selectedValue,
            items: cleanedLocations,
            onChanged: (value) {
              if (value != null) {
                onLocationChanged(value);
              }
            },
            itemLabel: (v) => v,
          ),
        ],
      ),
    );
  }
}
