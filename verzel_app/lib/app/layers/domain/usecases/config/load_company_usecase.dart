
import 'package:dartz/dartz.dart';
import 'package:verzel_app/app/common/models/failure_models.dart';
import 'package:verzel_app/app/common/usecase.dart';
import 'package:verzel_app/app/layers/domain/repositories/config_repository.dart';

class LoadCompanyUsecase implements Usecase<NoParams, String> {
  final IConfigRepository repository;

  LoadCompanyUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.loadCompany();
  }
}
