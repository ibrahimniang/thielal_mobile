import '../data/models/center_model.dart';

abstract class CentersRepository {
  Future<List<CenterModel>> getCenters();
}
