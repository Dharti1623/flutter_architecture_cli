import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Gradient? gradient;

  const AppBackground({
    super.key,
    required this.child,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        gradient: gradient,
      ),
      child: child,
    );
  }
}
