// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\route_selection.dart
import 'package:flutter/material.dart';
import '../../constants/drug_use_catalog.dart';

class RouteSelection extends StatelessWidget {
  final String route;
  final ValueChanged<String> onRouteChanged;

  const RouteSelection({
    super.key,
    required this.route,
    required this.onRouteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: DrugUseCatalog.consumptionMethods.map((method) {
        return ChoiceChip(
          label: Text('${method['emoji']} ${method['name']!.toUpperCase()}'),
          selected: route == method['name']!,
          onSelected: (_) => onRouteChanged(method['name']!),
        );
      }).toList(),
    );
  }
}