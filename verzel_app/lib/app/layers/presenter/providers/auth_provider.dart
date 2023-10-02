import 'package:flutter/material.dart';
import 'package:verzel_app/app/layers/domain/usecases/auth/sign_in_usecase.dart';
import 'package:verzel_app/app/layers/presenter/providers/config_provider.dart';
import 'package:verzel_app/app/layers/presenter/providers/user_provider.dart';
import 'package:verzel_app/functions.dart';

class AuthProvider extends ChangeNotifier {
  final SignInUsecase _signInUsecase;

  late UserProvider userProvider;
  late ConfigProvider _configProvider;

  AuthProvider(
    this._signInUsecase,
  );

  void setUserProvider(UserProvider provider) => userProvider = provider;
  void setConfigProvider(ConfigProvider provider) => _configProvider = provider;

  Future<String> signIn(
      BuildContext context, bool mounted, email, password) async {
    var value = '';
    final result = await _signInUsecase([email, password, value]);
    await _configProvider.saveLastLoggedEmail(email);
    await _configProvider.saveLastLoggedPassword(password);

    // if (mounted) {
    return result.fold(
      (l) async {
        showFlushbar(
          context,
          l.title!,
          l.message!,
          3,
        );
        return '';
      },
      (r) {
        Map value = r[0] as Map;
        return value['token'];
      },
    );
    // }
  }
}
