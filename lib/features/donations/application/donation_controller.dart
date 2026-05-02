import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/donation_model.dart';
import '../data/repositories/donation_repository.dart';
import '../../auth/application/auth_controller.dart';

/// ==========================
/// Repository Provider
/// ==========================
final donationRepositoryProvider =
    Provider<DonationRepository>((ref) {
  return DonationRepository();
});

/// ==========================
/// My Donations Provider
/// ==========================
final myDonationsProvider =
    FutureProvider<List<DonationModel>>((ref) async {
  final repo = ref.read(donationRepositoryProvider);

  final authState = ref.read(authControllerProvider);
  final token = authState.accessToken;

  if (token == null || token.isEmpty) {
    throw Exception("Token manquant");
  }

  return repo.getMyDonations(token);
});