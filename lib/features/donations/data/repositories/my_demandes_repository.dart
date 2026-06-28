import '../models/my_demande_model.dart';
import '../services/my_demandes_service.dart';

class MyDemandesRepository {
  final MyDemandesService service;

  MyDemandesRepository(this.service);

  Future<List<MyDemandeModel>>
  fetchMyDemandes() async {

    final response =
        await service.getMyDemandes();

    final data = response.data;

    if (data["success"] == true &&
        data["data"] != null) {

      return (data["data"] as List)
          .map(
            (e) =>
                MyDemandeModel.fromJson(e),
          )
          .toList();
    }

    return [];
  }
}