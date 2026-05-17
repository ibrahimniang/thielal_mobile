import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/nearby_donor_model.dart';

import '../../data/repositories/nearby_donors_repository.dart';

/// ======================================
/// PARAMS TYPE
/// ======================================

typedef NearbyParams =
    ({
      String ville,
      String groupe,
      double latitude,
      double longitude,
      int utilisateurId,
    });

/// ======================================
/// REPOSITORY
/// ======================================

final nearbyDonorsRepositoryProvider = Provider(
  (ref) => NearbyDonorsRepository(),
);

/// ======================================
/// PROVIDER
/// ======================================

final nearbyDonorsProvider =
    FutureProvider.family<List<NearbyDonorModel>, NearbyParams>((
      ref,
      params,
    ) async {
      debugPrint('🚀 PROVIDER START');

      debugPrint('🏙️ PROVIDER CITY => ${params.ville}');

      debugPrint('🩸 PROVIDER GROUP => ${params.groupe}');

      return ref
          .read(nearbyDonorsRepositoryProvider)
          .getNearbyDonors(
            ville: params.ville,

            groupe: params.groupe,

            latitude: params.latitude,

            longitude: params.longitude,

            utilisateurId: params.utilisateurId,
          );
    });
