class Formatters {
  Formatters._();

  static String formatFullName({String? firstName, String? lastName}) {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    return '$first $last'.trim();
  }

  static String maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    final visible = phone.substring(phone.length - 4);
    return '••••••$visible';
  }

  static String safeText(String? value, {String fallback = '-'}) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value.trim();
  }
}
