import 'package:verzel_app/app/layers/data/datasources/local/config_datasource.dart';
import 'package:verzel_app/app/layers/data/datasources/local/config_datasource_implementation.dart';
import 'package:verzel_app/app/layers/data/datasources/remote/remote_data_datasource.dart';
import 'package:verzel_app/app/layers/data/datasources/remote/remote_data_datasource_implementation.dart';
import 'package:verzel_app/app/layers/data/repositories/config_repository_implementation.dart';
import 'package:verzel_app/app/layers/data/repositories/data_repository_implementation.dart';
import 'package:verzel_app/app/layers/domain/repositories/config_repository.dart';
import 'package:verzel_app/app/layers/domain/repositories/data_repository.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/load_addresses_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/load_company_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/load_config_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/load_last_logged_email.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/load_last_logged_password.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/save_addresses_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/save_company_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/save_config_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/save_last_logged_email.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/save_last_logged_password.dart';
import 'package:verzel_app/app/layers/domain/usecases/config/version_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/delete_car_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/edit_car_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/new_car_usecase.dart';
import 'package:verzel_app/app/layers/domain/usecases/data/response_data_usecase.dart';
import 'package:verzel_app/app/layers/presenter/providers/config_provider.dart';
import 'package:verzel_app/app/layers/presenter/providers/data_provider.dart';
import 'package:verzel_app/app/layers/presenter/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app/common/http/http_client.dart';
import 'app/common/http/http_client_implementation.dart';
import 'app/layers/data/datasources/remote/auth_datasource.dart';
import 'app/layers/data/datasources/remote/auth_datasource_implementation.dart';
import 'app/layers/data/repositories/auth_repository_implementation.dart';
import 'app/layers/domain/repositories/auth_repository.dart';
import 'app/layers/domain/usecases/auth/sign_in_usecase.dart';
import 'app/layers/presenter/providers/auth_provider.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...consumableProviders,
];

List<SingleChildWidget> independentServices = [
  Provider<IHttpClient>(create: (_) => HttpClientImplementation()),
  Provider<IConfigDatasource>(
      create: (context) => ConfigDatasourceImplementation()),
  Provider<IConfigRepository>(
      create: (context) => ConfigRepositoryImplementation(context.read())),
];

List<SingleChildWidget> dependentServices = [
  Provider<IAuthDatasource>(
    create: (context) => AuthDatasourceImplementation(context.read()),
  ),
  Provider<IAuthRepository>(
    create: (context) => AuthRepositoryImplementation(context.read()),
  ),
  // Provider<IUserDatasource>(
  //     create: (context) => UserDatasourceImplementation(context.read())),
  // Provider<IUserRepository>(
  //     create: (context) => UserRepositoryImplementation(context.read())),
  // Provider<IStorageRepository>(
  //     create: (context) => StorageRepositoryImplementation(context.read())),
  // Provider<ILocalDataDatasource>(
  //     create: (context) => LocalDataDatasourceImplementation()),
  Provider<IRemoteDataDatasource>(
      create: (context) => RemoteDataDatasourceImplementation(context.read())),
  Provider<IDataRepository>(
      create: (context) => DataRepositoryImplementation(context.read())),

  ////////////////////////////CONFING_DATASOURCE////////////////////////////////
  Provider(create: (context) => LoadAddressesUsecase(context.read())),
  Provider(create: (context) => SaveAddressesUsecase(context.read())),
  Provider(create: (context) => LoadLastLoggedEmailUsecase(context.read())),
  Provider(create: (context) => SaveLastLoggedEmailUsecase(context.read())),
  Provider(create: (context) => LoadLastLoggedPasswordUsecase(context.read())),
  Provider(create: (context) => SaveLastLoggedPasswordUsecase(context.read())),
  Provider(create: (context) => VersionUsecase(context.read())),
  Provider(create: (context) => CompanyUsecase(context.read())),
  Provider(create: (context) => LoadCompanyUsecase(context.read())),
  Provider(create: (context) => SaveConfigUsecase(context.read())),
  Provider(create: (context) => LoadConfigUsecase(context.read())),

  ////////////////////////////AUTH_DATASOURCE///////////////////////////////////
  Provider(create: (context) => SignInUsecase(context.read())),

  ////////////////////////////DATA_PROVIDER/////////////////////////////////////
  Provider(create: (context) => ResponseDatasUsecase(context.read())),
  Provider(create: (context) => NewCarUsecase(context.read())),
  Provider(create: (context) => EditCarUsecase(context.read())),
  Provider(create: (context) => DeleteCarUsecase(context.read())),
];

List<SingleChildWidget> consumableProviders = [
  ChangeNotifierProvider(
    create: (context) => ConfigProvider(
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => AuthProvider(
      context.read(),
    ),
  ),
  ChangeNotifierProxyProvider<ConfigProvider, UserProvider>(
    create: (context) => UserProvider(),
    update: (_, configProvider, userProvider) =>
        userProvider!..setConfigProvider(configProvider),
  ),
  ChangeNotifierProxyProvider2<ConfigProvider, UserProvider, AuthProvider>(
    create: (context) => AuthProvider(
      context.read(),
    ),
    update: (_, configProvider, userProvider, authProvider) {
      authProvider!.setConfigProvider(configProvider);
      authProvider.setUserProvider(userProvider);
      return authProvider;
    },
  ),
  ChangeNotifierProxyProvider3<ConfigProvider, UserProvider, AuthProvider,
          DataProvider>(
      create: (context) => DataProvider(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
      update: (_, configProvider, userProvider, authProvider, dataProvider) {
        dataProvider!.setConfigProvider(configProvider);
        dataProvider.setUserProvider(userProvider);
        dataProvider.setAuthProvider(authProvider);
        return dataProvider;
      }),
];
