import 'package:flutter/material.dart';

class BottomSheetHelper {
  static void show(BuildContext context, {required Widget child}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => child,
    );
  }
}
