import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../data/models/profile_model.dart';
import '../data/services/profile_remote_service.dart';
import '../data/repositories/profile_repository.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<ProfileModel?>>((ref) {
      final service = ProfileRemoteService();
      final repo = ProfileRepository(service);
      return ProfileController(repo);
    });

class ProfileController extends StateNotifier<AsyncValue<ProfileModel?>> {
  final ProfileRepository _repo;

  ProfileController(this._repo) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();

      final user = await _repo.getProfile();

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    required String nom,
    required String prenom,
    String? ville,
    String? quartier,
  }) async {
    try {
      await _repo.updateProfile(
        nom: nom,
        prenom: prenom,
        ville: ville,
        quartier: quartier,
      );

      await loadProfile();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateLocation(double lat, double lng) async {
    try {
      await _repo.updateLocation(latitude: lat, longitude: lng);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> requestEmail(String email) async {
    try {
      await _repo.requestEmailChange(email);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    try {
      await _repo.verifyEmailChange(email, code);
      await loadProfile();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> requestPhone(String phone) async {
    try {
      await _repo.requestPhoneChange(phone);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyPhone(String phone, String code) async {
    try {
      await _repo.verifyPhoneChange(phone, code);
      await loadProfile();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
