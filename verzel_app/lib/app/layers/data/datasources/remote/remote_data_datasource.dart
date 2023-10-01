
abstract class IRemoteDataDatasource {
  Future<List<Object>> responseData(List<Object> objects);
  Future<List<Object>> newCar(List<Object> objects);
  Future<List<Object>> editCar(List<Object> objects);
  Future<List<Object>> deleteCar(List<Object> objects);
}
