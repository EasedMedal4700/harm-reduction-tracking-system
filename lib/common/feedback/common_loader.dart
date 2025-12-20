import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class CommonLoader extends StatelessWidget {
  final Color? color;
  final double? size;

  const CommonLoader({this.color, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    final acc = context.accent;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(color: color ?? acc.primary),
      ),
    );
  }
}
