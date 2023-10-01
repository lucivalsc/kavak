import 'package:dartz/dartz.dart';
import 'package:verzel_app/app/common/models/failure_models.dart';

abstract class IDataRepository {
  Future<Either<Failure, List<Object>>> responseData(List<Object> strings);
  Future<Either<Failure, List<Object>>> newCar(List<Object> strings);
  Future<Either<Failure, List<Object>>> editCar(List<Object> strings);
  Future<Either<Failure, List<Object>>> deleteCar(List<Object> strings);
}
