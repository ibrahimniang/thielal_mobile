extension StringX on String {
  String get capitalize {
    if (trim().isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isEmail {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(trim());
  }

  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^[0-9+\s]{8,20}$');
    return phoneRegex.hasMatch(trim());
  }
}
