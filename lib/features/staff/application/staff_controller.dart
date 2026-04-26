import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../domain/repositories/staff_repository.dart';
import '../data/repositories/staff_repository_impl.dart';
import '../data/services/staff_service.dart';
import '../../../core/network/dio_provider.dart';
import '../../../features/auth/application/auth_controller.dart';
import 'staff_state.dart';

/// ==========================
/// PROVIDERS
/// ==========================

final staffServiceProvider = Provider<StaffService>((ref) {
  final dio = ref.watch(dioProvider);
  return StaffService(dio);
});

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  final service = ref.watch(staffServiceProvider);
  return StaffRepositoryImpl(service);
});

final staffControllerProvider =
    StateNotifierProvider<StaffController, StaffState>((ref) {
      final repo = ref.watch(staffRepositoryProvider);
      return StaffController(ref, repo);
    });

/// ==========================
/// CONTROLLER
/// ==========================

class StaffController extends StateNotifier<StaffState> {
  final Ref ref;
  final StaffRepository _repository;

  StaffController(this.ref, this._repository) : super(const StaffState());

  int? get _currentRoleId =>
      ref.read(authControllerProvider).currentUser?.roleId;
  int? get _currentCentreId =>
      ref.read(authControllerProvider).currentUser?.centreId;

  // ==========================
  // BLOOD REQUESTS
  // ==========================

  Future<void> loadBloodRequests() async {
    state = state.copyWith(bloodRequests: const AsyncValue.loading());

    try {
      final data = await _repository.getBloodRequests();
      state = state.copyWith(bloodRequests: AsyncValue.data(data));
    } catch (e, st) {
      state = state.copyWith(bloodRequests: AsyncValue.error(e, st));
    }
  }

  Future<void> updateBloodRequestStatus({
    required int requestId,
    required String status,
  }) async {
    state = state.copyWith(actionStatus: const AsyncValue.loading());

    try {
      await _repository.updateBloodRequestStatus(
        requestId: requestId,
        status: status,
      );

      state = state.copyWith(actionStatus: const AsyncValue.data(true));

      await loadBloodRequests();
    } catch (e, st) {
      state = state.copyWith(actionStatus: AsyncValue.error(e, st));
    }
  }

  // ==========================
  // DONORS
  // ==========================

  Future<void> loadNearbyDonors({
    required String ville,
    required String groupe,
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(nearbyDonors: const AsyncValue.loading());

    try {
      final data = await _repository.getNearbyDonors(
        ville: ville,
        groupe: groupe,
        latitude: latitude,
        longitude: longitude,
      );

      state = state.copyWith(nearbyDonors: AsyncValue.data(data));
    } catch (e, st) {
      state = state.copyWith(nearbyDonors: AsyncValue.error(e, st));
    }
  }

  // ==========================
  // QR SCAN
  // ==========================

  Future<void> scanQr({required String qrData}) async {
    state = state.copyWith(scannedQr: const AsyncValue.loading());

    try {
      final centreId = _currentCentreId;

      if (centreId == null) {
        throw Exception("Centre introuvable pour cet utilisateur");
      }

      final data = await _repository.scanQr(qrData: qrData, centreId: centreId);

      state = state.copyWith(scannedQr: AsyncValue.data(data));
    } catch (e, st) {
      state = state.copyWith(scannedQr: AsyncValue.error(e, st));
    }
  }

  // ==========================
  // QR GENERATION
  // ==========================

  Future<void> generateQr(int userId) async {
    state = state.copyWith(generatedQr: const AsyncValue.loading());

    try {
      final qr = await _repository.generateQr(userId: userId);
      print('QR DEBUG -> generated qr length: ${qr.length}');
      state = state.copyWith(generatedQr: AsyncValue.data(qr));
    } catch (e, st) {
      print('QR DEBUG -> generateQr error: $e');
      print('QR DEBUG -> stack: $st');
      state = state.copyWith(generatedQr: AsyncValue.error(e, st));
    }
  }

  // ==========================
  // BLOOD STOCK
  // ==========================

  Future<void> loadBloodStock() async {
    state = state.copyWith(bloodStock: const AsyncValue.loading());

    try {
      final roleId = _currentRoleId;
      final centreId = _currentCentreId;

      if (roleId == 1) {
        final data = await _repository.getAllBloodStocks();
        state = state.copyWith(bloodStock: AsyncValue.data(data));
        return;
      }

      if (centreId == null) {
        state = state.copyWith(bloodStock: const AsyncValue.data([]));
        return;
      }

      final data = await _repository.getBloodStockByCentre(centreId: centreId);

      state = state.copyWith(bloodStock: AsyncValue.data(data));
    } catch (e, st) {
      state = state.copyWith(bloodStock: AsyncValue.error(e, st));
    }
  }

  Future<void> updateBloodStock({
    required String groupeSanguin,
    required int quantite,
    int? centreId,
  }) async {
    state = state.copyWith(actionStatus: const AsyncValue.loading());

    try {
      final roleId = _currentRoleId;
      final currentCentreId = _currentCentreId;

      final targetCentreId = roleId == 1 ? centreId : currentCentreId;

      if (targetCentreId == null) {
        throw Exception("Centre introuvable pour la mise à jour du stock");
      }

      await _repository.updateBloodStock(
        centreId: targetCentreId,
        groupeSanguin: groupeSanguin,
        quantite: quantite,
      );

      state = state.copyWith(actionStatus: const AsyncValue.data(true));

      await loadBloodStock();
    } catch (e, st) {
      state = state.copyWith(actionStatus: AsyncValue.error(e, st));
    }
  }

  // ==========================
  // BLOOD GROUP VERIFICATION
  // ==========================

  Future<void> verifyBloodGroup({
    required int userId,
    required String groupeSanguin,
  }) async {
    state = state.copyWith(actionStatus: const AsyncValue.loading());

    try {
      await _repository.verifyBloodGroup(
        userId: userId,
        groupeSanguin: groupeSanguin,
      );

      state = state.copyWith(actionStatus: const AsyncValue.data(true));
    } catch (e, st) {
      state = state.copyWith(actionStatus: AsyncValue.error(e, st));
    }
  }

  // ==========================
  // CREATE STAFF
  // ==========================

  Future<void> createStaff({
    required String nom,
    required String prenom,
    required String genre,
    required String dateNaissance,
    required String telephone,
    required String email,
    required String password,
    required String ville,
    required String quartier,
  }) async {
    state = state.copyWith(actionStatus: const AsyncValue.loading());

    try {
      await _repository.createStaff(
        nom: nom,
        prenom: prenom,
        genre: genre,
        dateNaissance: dateNaissance,
        telephone: telephone,
        email: email,
        password: password,
        ville: ville,
        quartier: quartier,
      );

      state = state.copyWith(actionStatus: const AsyncValue.data(true));
    } catch (e, st) {
      state = state.copyWith(actionStatus: AsyncValue.error(e, st));
    }
  }

  // ==========================
  // RESET ACTION STATUS
  // ==========================

  void resetActionStatus() {
    state = state.copyWith(actionStatus: const AsyncValue.data(false));
  }
}
