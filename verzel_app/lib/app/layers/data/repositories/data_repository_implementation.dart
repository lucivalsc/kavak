import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:verzel_app/app/common/models/exception_models.dart';
import 'package:verzel_app/app/common/models/failure_models.dart';
import 'package:verzel_app/app/layers/data/datasources/remote/remote_data_datasource.dart';
import 'package:verzel_app/app/layers/domain/repositories/data_repository.dart';

class DataRepositoryImplementation implements IDataRepository {
  final IRemoteDataDatasource remoteDatasource;
  final socketError = const Failure(
      failureType: "SocketFailure",
      title: "Falha de Conexão",
      message: "Não foi possível estabelecer conexão com o servidor.");

  DataRepositoryImplementation(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Object>>> responseData(
      List<Object> objects) async {
    try {
      final result = await remoteDatasource.responseData(objects);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
          failureType: "ServerFailure", title: e.title, message: e.message));
    } on SocketException {
      return Left(socketError);
    }
  }

  @override
  Future<Either<Failure, List<Object>>> newCar(List<Object> objects) async {
    try {
      final result = await remoteDatasource.newCar(objects);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
          failureType: "ServerFailure", title: e.title, message: e.message));
    } on SocketException {
      return Left(socketError);
    }
  }

  @override
  Future<Either<Failure, List<Object>>> editCar(List<Object> objects) async {
    try {
      final result = await remoteDatasource.editCar(objects);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
          failureType: "ServerFailure", title: e.title, message: e.message));
    } on SocketException {
      return Left(socketError);
    }
  }

  @override
  Future<Either<Failure, List<Object>>> deleteCar(List<Object> objects) async {
    try {
      final result = await remoteDatasource.deleteCar(objects);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
          failureType: "ServerFailure", title: e.title, message: e.message));
    } on SocketException {
      return Left(socketError);
    }
  }
}
