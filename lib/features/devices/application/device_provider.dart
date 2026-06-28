import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/device_repository.dart';
import '../domain/models/device_model.dart';

final deviceRepositoryProvider =
    Provider<DeviceRepository>(
  (ref) => DeviceRepository(),
);

final myDevicesProvider =
    FutureProvider<List<DeviceModel>>(
  (ref) async {
    return ref
        .read(deviceRepositoryProvider)
        .getMyDevices();
  },
);