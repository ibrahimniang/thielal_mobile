import 'package:dio/dio.dart';
import '../../../../core/config/api_endpoints.dart';

class StaffService {
  final Dio dio;

  StaffService(this.dio);

  // ==========================
  // BLOOD REQUESTS
  // ==========================
  Future<Response> getBloodRequests() {
    return dio.get(ApiEndpoints.demandes);
  }

  Future<Response> updateBloodRequestStatus({
    required int requestId,
    required String status,
  }) {
    return dio.patch(
      "${ApiEndpoints.demandes}/$requestId",
      data: {"status": status},
    );
  }

  // ==========================
  // DONORS
  // ==========================
  Future<Response> getNearbyDonors({
    required String ville,
    required String groupe,
    required double latitude,
    required double longitude,
  }) {
    return dio.post(
      ApiEndpoints.nearbyDonors,
      data: {
        "ville": ville,
        "groupe": groupe,
        "latitude": latitude,
        "longitude": longitude,
      },
    );
  }

  // ==========================
  // QR
  // ==========================
  Future<Response> scanQr({required String qrData, required int centreId}) {
    return dio.post(
      ApiEndpoints.scanQr,
      data: {"qrData": qrData, "centre_id": centreId},
    );
  }

  Future<Response> generateQr(int userId) async {
    print('QR DEBUG -> generating for userId: $userId');
    final res = await dio.post(
      ApiEndpoints.generateQr,
      data: {"userId": userId},
    );
    print('QR DEBUG -> response: ${res.data}');
    return res;
  }

  // ==========================
  // BLOOD STOCK
  // ==========================
  Future<Response> getBloodStockByCentre(int centreId) {
    return dio.get("${ApiEndpoints.banqueCentre}/$centreId");
  }

  Future<Response> getAllBloodStocks() {
    return dio.get(ApiEndpoints.banque);
  }

  Future<Response> updateBloodStock({
    required int centreId,
    required String groupeSanguin,
    required int quantite,
  }) {
    return dio.post(
      ApiEndpoints.banque,
      data: {
        "centre_id": centreId,
        "groupe_sanguin": groupeSanguin,
        "quantite": quantite,
      },
    );
  }

  // ==========================
  // VERIFY BLOOD GROUP
  // ==========================
  Future<Response> verifyBloodGroup({
    required int userId,
    required String groupeSanguin,
  }) {
    return dio.patch(
      ApiEndpoints.verifyBloodGroupByUserId(userId),
      data: {"groupe_sanguin": groupeSanguin},
    );
  }

  // ==========================
  // CREATE STAFF (DIRECTOR)
  // ==========================
  Future<Response> createStaff({
    required String nom,
    required String prenom,
    required String genre,
    required String dateNaissance,
    required String telephone,
    required String email,
    required String password,
    required String ville,
    required String quartier,
  }) {
    return dio.post(
      "/users/director/create-staff",
      data: {
        "nom": nom,
        "prenom": prenom,
        "genre": genre,
        "date_naissance": dateNaissance,
        "telephone": telephone,
        "email": email,
        "password": password,
        "ville": ville,
        "quartier": quartier,
      },
    );
  }
}
