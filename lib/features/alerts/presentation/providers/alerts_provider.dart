import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/alert_model.dart';
import '../../data/repositories/alert_repository.dart';

final alertsRepositoryProvider = Provider((ref) => AlertRepository());

final alertsProvider = FutureProvider<List<AlertModel>>((ref) async {
  return ref.read(alertsRepositoryProvider).getAlerts();
});
