class Validators {
  Validators._();

  static String? requiredField(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L’email est obligatoire';
    }

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Veuillez entrer un email valide';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est obligatoire';
    }

    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro de téléphone est obligatoire';
    }

    final regex = RegExp(r'^[0-9+\s]{8,20}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Veuillez entrer un numéro valide';
    }

    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le code OTP est obligatoire';
    }

    if (value.trim().length < 4) {
      return 'Le code OTP est invalide';
    }

    return null;
  }
}
