/// Helper utility class for string manipulation and case conversions.
class StringUtils {
  StringUtils._();
  /// Converts input string to PascalCase (e.g., "user_profile" -> "UserProfile")
  static String toPascalCase(String input) {
    if (input.isEmpty) return '';
    final words = _splitWords(input);
    return words.map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase()).join('');
  }

  /// Converts input string to camelCase (e.g., "user_profile" -> "userProfile")
  static String toCamelCase(String input) {
    if (input.isEmpty) return '';
    final pascal = toPascalCase(input);
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  /// Converts input string to snake_case (e.g., "userProfile" -> "user_profile")
  static String toSnakeCase(String input) {
    if (input.isEmpty) return '';
    final words = _splitWords(input);
    return words.map((w) => w.toLowerCase()).join('_');
  }

  /// Converts input string to kebab-case (e.g., "userProfile" -> "user-profile")
  static String toKebabCase(String input) {
    if (input.isEmpty) return '';
    final words = _splitWords(input);
    return words.map((w) => w.toLowerCase()).join('-');
  }

  /// Helper to split string into list of words by looking at capitals, spaces, dashes, and underscores.
  static List<String> _splitWords(String input) {
    final exp = RegExp(r'(?<=[a-z])(?=[A-Z])|[_.\-\s]+');
    return input
        .split(exp)
        .where((w) => w.trim().isNotEmpty)
        .toList();
  }
}
