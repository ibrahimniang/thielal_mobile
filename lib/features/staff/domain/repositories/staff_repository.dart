import '../../data/models/blood_request_model.dart';
import '../../data/models/donor_model.dart';
import '../../data/models/qr_model.dart';
import '../../data/models/blood_stock_model.dart';

abstract class StaffRepository {
  // ==========================
  // BLOOD REQUESTS
  // ==========================
  Future<List<BloodRequestModel>> getBloodRequests();

  Future<void> updateBloodRequestStatus({
    required int requestId,
    required String status,
  });

  // ==========================
  // DONORS
  // ==========================
  Future<List<DonorModel>> getNearbyDonors({
    required String ville,
    required String groupe,
    required double latitude,
    required double longitude,
  });

  // ==========================
  // QR CODE
  // ==========================
  Future<QrModel> scanQr({required String qrData, required int centreId});

  Future<String> generateQr({required int userId});

  // ==========================
  // BLOOD STOCK
  // ==========================
  Future<List<BloodStockModel>> getBloodStockByCentre({required int centreId});

  Future<List<BloodStockModel>> getAllBloodStocks();

  Future<void> updateBloodStock({
    required int centreId,
    required String groupeSanguin,
    required int quantite,
  });

  // ==========================
  // BLOOD GROUP VERIFICATION
  // ==========================
  Future<void> verifyBloodGroup({
    required int userId,
    required String groupeSanguin,
  });

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
  });
}
