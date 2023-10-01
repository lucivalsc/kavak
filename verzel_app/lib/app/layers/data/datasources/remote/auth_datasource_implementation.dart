import '../../../../common/http/http_client.dart';
import 'auth_datasource.dart';

class AuthDatasourceImplementation implements IAuthDatasource {
  final Map<String, String> headers = {"Content-Type": "application/json"};
  final IHttpClient client;

  AuthDatasourceImplementation(this.client);

  @override
  Future<List<Object>> signIn(List<Object> object) async {
    // var username = object[0] as String;
    // var password = object[1] as String;
    try {
      // var response = await client.post(
      //   url: 'http://${Endpoints.resource}/Login',
      //   headers: Map.from(headers),
      //   payload: {"login": username, "senha": password},
      // );

      return [
        {
          "success": true,
          "ucusername": "Admin",
          "uclogin": "admin",
          "ucemail": "admin@gmail.com",
          "empresas": [
            {
              "guid": "6EC7AC88F41876EC6FAED754C7C438323D5B",
              "uciduser": "1",
              "empresa": "Empresa de Testes",
              "cnpj": "1"
            }
          ]
        }
      ];

      // if (response.statusCode >= 200 && response.statusCode < 300) {
      //   return [response.data];
      // } else {
      //   throw ServerException(
      //       statusCode: response.statusCode,
      //       title: 'Falha de Autenticação',
      //       message: 'Credenciais incorretas!');
      // }
    } catch (e) {
      rethrow;
    }
  }

  void login(String username, String password) {}
}
