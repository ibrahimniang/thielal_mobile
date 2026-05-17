import '../../../../core/network/api_client.dart';

class CentersRemoteService {
  final api = ApiClient().dio;

  Future<List<dynamic>> getCenters() async {
    final response = await api.get('/centres');
    print(response.data);

    return response.data['data'];
  }
}
