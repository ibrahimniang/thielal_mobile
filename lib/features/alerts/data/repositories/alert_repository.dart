import '../models/alert_model.dart';
import '../services/alert_service.dart';

class AlertRepository {
  final AlertService _service = AlertService();

  Future<List<AlertModel>> getAlerts() async {
    final response = await _service.getAlerts();

    final List alerts = response.data['data'];

    return alerts.map((e) => AlertModel.fromJson(e)).toList();
  }
}
