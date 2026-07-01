extension StringExtensions on String {
  bool get isValidEmail =>
      RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$').hasMatch(this);
}
