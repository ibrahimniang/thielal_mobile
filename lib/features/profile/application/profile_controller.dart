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

  // ==========================
  // LOAD PROFILE
  // ==========================
  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();

      final user = await _repo.getProfile();

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ==========================
  // UPDATE PROFILE
  // ==========================
  Future<void> updateProfile({
    required String nom,
    required String prenom,
    String? ville,
    String? quartier,
  }) async {
    final previous = state.maybeWhen(data: (user) => user, orElse: () => null);

    try {
      await _repo.updateProfile(
        nom: nom,
        prenom: prenom,
        ville: ville,
        quartier: quartier,
      );

      await loadProfile();
    } catch (e, st) {
      if (previous != null) {
        state = AsyncValue.data(previous);
      } else {
        state = AsyncValue.error(e, st);
      }
      rethrow;
    }
  }

  // ==========================
  // UPDATE LOCATION
  // ==========================
  Future<void> updateLocation(double lat, double lng) async {
    try {
      await _repo.updateLocation(latitude: lat, longitude: lng);
      await loadProfile();
    } catch (e, st) {
      print('PROFILE DEBUG -> updateLocation error: $e');
    }
  }

  // ==========================
  // EMAIL CHANGE
  // ==========================
  Future<void> requestEmail(String email) async {
    try {
      await _repo.requestEmailChange(email);
    } catch (e, st) {
      print('PROFILE DEBUG -> requestEmail error: $e');
      rethrow;
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    final previous = state.maybeWhen(data: (user) => user, orElse: () => null);

    try {
      await _repo.verifyEmailChange(email, code);
      await loadProfile();
    } catch (e, st) {
      if (previous != null) {
        state = AsyncValue.data(previous);
      } else {
        state = AsyncValue.error(e, st);
      }
      rethrow;
    }
  }

  // ==========================
  // PHONE CHANGE
  // ==========================
  Future<void> requestPhone(String phone) async {
    try {
      await _repo.requestPhoneChange(phone);
    } catch (e, st) {
      print('PROFILE DEBUG -> requestPhone error: $e');
      rethrow;
    }
  }

  Future<void> verifyPhone(String phone, String code) async {
    final previous = state.maybeWhen(data: (user) => user, orElse: () => null);

    try {
      await _repo.verifyPhoneChange(phone, code);
      await loadProfile();
    } catch (e, st) {
      if (previous != null) {
        state = AsyncValue.data(previous);
      } else {
        state = AsyncValue.error(e, st);
      }
      rethrow;
    }
  }

  // ==========================
  // MANUAL REFRESH
  // ==========================
  Future<void> refreshProfile() async {
    await loadProfile();
  }
}
