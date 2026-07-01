import 'package:flutter/material.dart';
import 'package:test_app_dir/core/localization/app_localizations.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final Map<String, dynamic>? params;

  const AppText({
    super.key,
    required this.text,
    this.style,
    this.align,
    this.maxLines,
    this.overflow,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    String translatedText = AppLocalizations.of(context).translate(text);
    if (params != null) {
      params!.forEach((key, value) {
        translatedText = translatedText.replaceAll('{$key}', value.toString());
      });
    }
    return Text(
      translatedText,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
