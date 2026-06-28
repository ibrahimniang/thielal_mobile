import '../services/receipt_remote_service.dart';

class ReceiptRepository {
  final ReceiptService service;

  ReceiptRepository(this.service);

  Future<String> getReceiptToken(
    int demandeId,
  ) async {
    final response =
        await service.getReceipt(
      demandeId,
    );

    final data = response.data;

    if (data["success"] == true) {
      return data["receipt"]["token"];
    }

    throw Exception(
      "Impossible de récupérer le reçu.",
    );
  }
}