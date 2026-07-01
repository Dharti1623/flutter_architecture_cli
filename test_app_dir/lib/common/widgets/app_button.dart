import 'package:flutter/material.dart';
import 'package:test_app_dir/common/widgets/app_loader.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppLoader();
    }

    if (isOutline) {
      return OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
