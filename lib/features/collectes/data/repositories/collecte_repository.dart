import '../models/collecte_model.dart';
import '../services/collecte_service.dart';

class CollecteRepository {
  final CollecteService _service = CollecteService();

  Future<List<CollecteModel>> getCollectes() async {
    final response = await _service.getCollectes();

    final List collectes = response.data['data'];

    return collectes.map((e) => CollecteModel.fromJson(e)).toList();
  }

  Future<void> participer({
    required int collecteId,
    required int utilisateurId,
  }) async {
    await _service.participer(collecteId, utilisateurId);
  }
}
