import '../../domain/repositories/staff_repository.dart';
import '../models/blood_request_model.dart';
import '../models/donor_model.dart';
import '../models/qr_model.dart';
import '../models/blood_stock_model.dart';
import '../services/staff_service.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffService service;

  StaffRepositoryImpl(this.service);

  // ==========================
  // BLOOD REQUESTS
  // ==========================
  @override
  Future<List<BloodRequestModel>> getBloodRequests() async {
    final res = await service.getBloodRequests();
    final payload = _extractPayload(res.data);

    if (payload is List) {
      return payload.map((e) => BloodRequestModel.fromJson(e)).toList();
    }

    if (payload is Map<String, dynamic> && payload['data'] is List) {
      return (payload['data'] as List)
          .map((e) => BloodRequestModel.fromJson(e))
          .toList();
    }

    return [];
  }

  @override
  Future<void> updateBloodRequestStatus({
    required int requestId,
    required String status,
  }) async {
    await service.updateBloodRequestStatus(
      requestId: requestId,
      status: status,
    );
  }

  // ==========================
  // DONORS
  // ==========================
  @override
  Future<List<DonorModel>> getNearbyDonors({
    required String ville,
    required String groupe,
    required double latitude,
    required double longitude,
  }) async {
    final res = await service.getNearbyDonors(
      ville: ville,
      groupe: groupe,
      latitude: latitude,
      longitude: longitude,
    );

    final payload = _extractPayload(res.data);

    if (payload is Map<String, dynamic> && payload['donneurs'] is List) {
      return (payload['donneurs'] as List)
          .map((e) => DonorModel.fromJson(e))
          .toList();
    }

    if (payload is Map<String, dynamic> && payload['data'] is List) {
      return (payload['data'] as List)
          .map((e) => DonorModel.fromJson(e))
          .toList();
    }

    if (payload is List) {
      return payload.map((e) => DonorModel.fromJson(e)).toList();
    }

    return [];
  }

  // ==========================
  // QR CODE
  // ==========================
  @override
  Future<QrModel> scanQr({
    required String qrData,
    required int centreId,
  }) async {
    final res = await service.scanQr(qrData: qrData, centreId: centreId);

    final payload = _extractPayload(res.data);

    if (payload is Map<String, dynamic>) {
      return QrModel.fromJson(payload);
    }

    return QrModel(qrCode: qrData, userId: 0);
  }

  @override
  Future<String> generateQr({required int userId}) async {
    final res = await service.generateQr(userId);
    final payload = _extractPayload(res.data);

    if (payload is Map<String, dynamic>) {
      if (payload['qr'] is Map<String, dynamic>) {
        final qrMap = payload['qr'] as Map<String, dynamic>;
        final qrValue = qrMap['qr'];

        if (qrValue != null) {
          return qrValue.toString();
        }
      }

      if (payload['qr_code'] != null) {
        return payload['qr_code'].toString();
      }

      if (payload['qr'] is String) {
        return payload['qr'].toString();
      }
    }

    return '';
  }

  // ==========================
  // BLOOD STOCK
  // ==========================
  @override
  Future<List<BloodStockModel>> getBloodStockByCentre({
    required int centreId,
  }) async {
    final res = await service.getBloodStockByCentre(centreId);
    final payload = _extractPayload(res.data);

    if (payload is Map<String, dynamic> && payload['data'] is List) {
      return (payload['data'] as List)
          .map((e) => BloodStockModel.fromJson(e))
          .toList();
    }

    if (payload is List) {
      return payload.map((e) => BloodStockModel.fromJson(e)).toList();
    }

    return [];
  }

  @override
  Future<List<BloodStockModel>> getAllBloodStocks() async {
    final res = await service.getAllBloodStocks();
    final payload = _extractPayload(res.data);

    if (payload is Map<String, dynamic> && payload['data'] is List) {
      return (payload['data'] as List)
          .map((e) => BloodStockModel.fromJson(e))
          .toList();
    }

    if (payload is List) {
      return payload.map((e) => BloodStockModel.fromJson(e)).toList();
    }

    return [];
  }

  @override
  Future<void> updateBloodStock({
    required int centreId,
    required String groupeSanguin,
    required int quantite,
  }) async {
    await service.updateBloodStock(
      centreId: centreId,
      groupeSanguin: groupeSanguin,
      quantite: quantite,
    );
  }

  // ==========================
  // BLOOD GROUP VERIFICATION
  // ==========================
  @override
  Future<void> verifyBloodGroup({
    required int userId,
    required String groupeSanguin,
  }) async {
    await service.verifyBloodGroup(
      userId: userId,
      groupeSanguin: groupeSanguin,
    );
  }

  // ==========================
  // CREATE STAFF
  // ==========================
  @override
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
    await service.createStaff(
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
  }

  dynamic _extractPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return data;
  }
}
