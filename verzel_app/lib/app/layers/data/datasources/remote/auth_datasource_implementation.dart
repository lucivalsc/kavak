import 'package:verzel_app/app/common/endpoints/endpoints.dart';
import 'package:verzel_app/app/common/models/exception_models.dart';

import '../../../../common/http/http_client.dart';
import 'auth_datasource.dart';

class AuthDatasourceImplementation implements IAuthDatasource {
  final Map<String, String> headers = {"Content-Type": "application/json"};
  final IHttpClient client;

  AuthDatasourceImplementation(this.client);

  @override
  Future<List<Object>> signIn(List<Object> object) async {
    var username = object[0] as String;
    var password = object[1] as String;
    try {
      var response = await client.post(
        url: '${Endpoints.resource}login',
        headers: Map.from(headers),
        payload: {"username": username, "password": password},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return [response.data];
      } else {
        throw ServerException(
            statusCode: response.statusCode,
            title: 'Falha de Autenticação',
            message: 'Credenciais incorretas!');
      }
    } catch (e) {
      rethrow;
    }
  }

  void login(String username, String password) {}
}
