import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final double thickness;
  final Color? color;

  const AppDivider({super.key, this.thickness = 1.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      color: color ?? Colors.grey[300],
    );
  }
}
