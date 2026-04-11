class ResponseFormatter {
  ResponseFormatter._();

  static String extractMessage(dynamic responseData) {
    if (responseData == null) {
      return 'Une erreur est survenue';
    }

    if (responseData is Map<String, dynamic>) {
      return responseData['message']?.toString() ??
          responseData['error']?.toString() ??
          'Une erreur est survenue';
    }

    return responseData.toString();
  }
}
