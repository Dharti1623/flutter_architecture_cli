import 'package:flutter/material.dart';

class DialogHelper {
  static void show(BuildContext context, {required Widget child}) {
    showDialog(
      context: context,
      builder: (_) => child,
    );
  }
}
