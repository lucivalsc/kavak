import 'dart:async';
import 'package:verzel_app/app/common/endpoints/endpoints.dart';
import 'package:verzel_app/app/common/http/http_client.dart';
import 'package:verzel_app/app/common/models/exception_models.dart';
import 'package:verzel_app/app/layers/data/datasources/remote/remote_data_datasource.dart';

class RemoteDataDatasourceImplementation implements IRemoteDataDatasource {
  final Map<String, String> headers = {"Content-Type": "application/json"};
  final token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Imx1Y2l2YWxzYyIsImlhdCI6MTY5NjEyMDg4NSwiZXhwIjoxNjk2MTI0NDg1fQ.blPtPV9qt6K2Q3iraqmIZ7wBNe5_bUyKhS6lMw4va6A';

  final IHttpClient client;

  RemoteDataDatasourceImplementation(this.client);

  @override
  Future<List<Object>> responseData(List<Object> objects) async {
    final int page = objects[0] as int;
    final int pageSize = objects[1] as int;
    try {
      final response = await client.get(
        url: '${Endpoints.resource}carros?page=$page&pageSize=$pageSize',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return [response.data];
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data["message"],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Object>> newCar(List<Object> objects) async {
    final payload = objects[0] as Map<String, dynamic>?;
    try {
      final response = await client.post(
        url: '${Endpoints.resource}carros',
        payload: payload,
        headers: headers
          ..addAll(
            {
              'Authorization': token,
            },
          ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return [response.data];
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data["message"],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Object>> editCar(List<Object> objects) async {
    final payload = objects[0] as Map<String, dynamic>?;
    try {
      final response = await client.post(
        url: '${Endpoints.resource}carros/editar',
        payload: payload,
        headers: headers
          ..addAll(
            {
              'Authorization': token,
            },
          ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return [response.data];
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data["message"],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Object>> deleteCar(List<Object> objects) async {
    final id = objects[0] as int;
    try {
      final response = await client.post(
        url: '${Endpoints.resource}carros/excluir',
        payload: {"id": id},
        headers: headers
          ..addAll(
            {
              'Authorization': token,
            },
          ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return [response.data];
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data["message"],
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
