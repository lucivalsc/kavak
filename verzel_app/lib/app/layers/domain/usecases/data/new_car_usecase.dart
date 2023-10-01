import 'package:dartz/dartz.dart';
import 'package:verzel_app/app/common/models/failure_models.dart';
import 'package:verzel_app/app/common/usecase.dart';
import 'package:verzel_app/app/layers/domain/repositories/data_repository.dart';

class NewCarUsecase implements Usecase<List<Object>, List<Object>> {
  final IDataRepository repository;

  const NewCarUsecase(this.repository);

  @override
  Future<Either<Failure, List<Object>>> call(List<Object> objects) async {
    return await repository.newCar(objects);
  }
}
