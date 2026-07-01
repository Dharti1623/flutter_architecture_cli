class AppRegex {
  static final RegExp email =
      RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
  static final RegExp phone = RegExp(r'^\+?[0-9]{10,12}$');
}
