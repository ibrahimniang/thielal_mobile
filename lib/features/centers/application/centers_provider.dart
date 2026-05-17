import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/center_model.dart';
import '../data/repositories/centers_repository_impl.dart';
import '../data/services/centers_remote_service.dart';

final centersProvider = FutureProvider<List<CenterModel>>((ref) async {
  final repository = CentersRepositoryImpl(CentersRemoteService());

  return repository.getCenters();
});
