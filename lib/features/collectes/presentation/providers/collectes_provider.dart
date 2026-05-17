import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/collecte_model.dart';
import '../../data/repositories/collecte_repository.dart';

final collectesRepositoryProvider = Provider((ref) => CollecteRepository());

final collectesProvider = FutureProvider<List<CollecteModel>>((ref) async {
  return ref.read(collectesRepositoryProvider).getCollectes();
});
