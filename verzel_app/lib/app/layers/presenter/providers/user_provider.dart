import 'package:flutter/material.dart';
import 'package:verzel_app/app/layers/presenter/providers/config_provider.dart';

class UserProvider extends ChangeNotifier {
  late ConfigProvider configProvider;
  UserProvider();
  void setConfigProvider(ConfigProvider provider) => configProvider = provider;
}
