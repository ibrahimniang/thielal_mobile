import '../../domain/centers_repository.dart';

import '../models/center_model.dart';
import '../services/centers_remote_service.dart';

class CentersRepositoryImpl implements CentersRepository {
  final CentersRemoteService service;

  CentersRepositoryImpl(this.service);

  @override
  Future<List<CenterModel>> getCenters() async {
    final data = await service.getCenters();

    return data.map<CenterModel>((e) => CenterModel.fromJson(e)).toList();
  }
}
