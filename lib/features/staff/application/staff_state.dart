import '../data/models/blood_request_model.dart';
import '../data/models/donor_model.dart';
import '../data/models/qr_model.dart';
import '../data/models/blood_stock_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffState {
  // ==========================
  // BLOOD REQUESTS
  // ==========================
  final AsyncValue<List<BloodRequestModel>> bloodRequests;

  // ==========================
  // DONORS
  // ==========================
  final AsyncValue<List<DonorModel>> nearbyDonors;

  // ==========================
  // QR SCAN RESULT
  // ==========================
  final AsyncValue<QrModel?> scannedQr;

  // ==========================
  // QR GENERATION
  // ==========================
  final AsyncValue<String?> generatedQr;

  // ==========================
  // BLOOD STOCK
  // ==========================
  final AsyncValue<List<BloodStockModel>> bloodStock;

  // ==========================
  // ACTION STATUS
  // ==========================
  final AsyncValue<bool> actionStatus;

  const StaffState({
    this.bloodRequests = const AsyncValue.data([]),
    this.nearbyDonors = const AsyncValue.data([]),
    this.scannedQr = const AsyncValue.data(null),
    this.generatedQr = const AsyncValue.data(null),
    this.bloodStock = const AsyncValue.data([]),
    this.actionStatus = const AsyncValue.data(false),
  });

  StaffState copyWith({
    AsyncValue<List<BloodRequestModel>>? bloodRequests,
    AsyncValue<List<DonorModel>>? nearbyDonors,
    AsyncValue<QrModel?>? scannedQr,
    AsyncValue<String?>? generatedQr,
    AsyncValue<List<BloodStockModel>>? bloodStock,
    AsyncValue<bool>? actionStatus,
  }) {
    return StaffState(
      bloodRequests: bloodRequests ?? this.bloodRequests,
      nearbyDonors: nearbyDonors ?? this.nearbyDonors,
      scannedQr: scannedQr ?? this.scannedQr,
      generatedQr: generatedQr ?? this.generatedQr,
      bloodStock: bloodStock ?? this.bloodStock,
      actionStatus: actionStatus ?? this.actionStatus,
    );
  }
}
