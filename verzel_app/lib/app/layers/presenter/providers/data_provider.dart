import 'package:flutter/material.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/delete_car_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/edit_car_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/new_car_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/response_data_usecase.dart';
import 'package:verzel_app/app/layers/presenter/providers/auth_provider.dart';
import 'package:verzel_app/app/layers/presenter/providers/config_provider.dart';
import 'package:verzel_app/app/layers/presenter/providers/user_provider.dart';
import 'package:verzel_app/functions.dart';

class DataProvider extends ChangeNotifier {
  final ResponseDatasUsecase datasUsecase;
  final NewCarUsecase newCarUsecase;
  final EditCarUsecase editCarUseCase;
  final DeleteCarUsecase deleteCarUsecase;

  DataProvider(
    this.datasUsecase,
    this.newCarUsecase,
    this.editCarUseCase,
    this.deleteCarUsecase,
  );

  late ConfigProvider configProvider;
  late UserProvider userProvider;
  late AuthProvider authProvider;
  void setConfigProvider(ConfigProvider provider) => configProvider = provider;
  void setUserProvider(UserProvider provider) => userProvider = provider;
  void setAuthProvider(AuthProvider provider) => authProvider = provider;

  Future<List?> responseDatas(
    BuildContext context,
    int page,
    int pageSize,
  ) async {
    final result = await datasUsecase([
      page,
      pageSize,
    ]);
    return result.fold(
      (l) async {
        showFlushbar(
          context,
          l.title!,
          l.message!,
          3,
        );
        return null;
      },
      (r) => r[0] as List,
    );
  }

  Future<bool> newCar(BuildContext context, Map<String, dynamic> value) async {
    final result = await newCarUsecase([value]);
    return result.fold(
      (l) async {
        showFlushbar(
          context,
          l.title!,
          l.message!,
          3,
        );
        return false;
      },
      (r) => true,
    );
  }

  Future<bool> editCar(
      BuildContext context, Map<dynamic, dynamic> value) async {
    final result = await editCarUseCase([value]);
    return result.fold(
      (l) async {
        showFlushbar(
          context,
          l.title!,
          l.message!,
          3,
        );
        return false;
      },
      (r) => true,
    );
  }

  Future<bool> deleteCar(BuildContext context, int value) async {
    final result = await deleteCarUsecase([value]);
    return result.fold(
      (l) async {
        showFlushbar(
          context,
          l.title!,
          l.message!,
          3,
        );
        return false;
      },
      (r) => true,
    );
  }

  Future<List> sortSyncedData(
      String searchBarText, List originals1, Map order) async {
    List searched;
    if (searchBarText.isEmpty) {
      searched = List.from(originals1);
    } else {
      searched = originals1.where((item) {
        if (item['nome']
            .toString()
            .toUpperCase()
            .contains(searchBarText.toUpperCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    searched.sort((a, b) => b['valor'].compareTo(a['valor']));

    if (order['type'] == 'DESC') {
      searched.sort((a, b) => b[order['value']].compareTo(a[order['value']]));
    } else {
      searched.sort((a, b) => a[order['value']].compareTo(b[order['value']]));
    }
    return searched;
  }

  void notify() {
    notifyListeners();
  }
}
