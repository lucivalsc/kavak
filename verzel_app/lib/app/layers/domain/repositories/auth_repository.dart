import 'package:dartz/dartz.dart';
import '../../../common/models/failure_models.dart';

abstract class IAuthRepository {
  Future<Either<Failure, List<Object>>> signIn(List<Object> object);
}
