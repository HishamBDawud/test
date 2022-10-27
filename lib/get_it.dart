import 'package:cleanapp/core/network/network_info.dart';
import 'package:cleanapp/services/authintication/data/data_sources/user_local_data_source.dart';
import 'package:cleanapp/services/authintication/data/data_sources/user_remote_data_source.dart';
import 'package:cleanapp/services/authintication/data/repositories/user_repo_impl.dart';
import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:cleanapp/services/authintication/domain/usecases/delete_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/get_user_details.dart';
import 'package:cleanapp/services/authintication/domain/usecases/is_first_time.dart';
import 'package:cleanapp/services/authintication/domain/usecases/login_user.dart';
import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/verify_user.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/IsFirstTime/IFT_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/Password/password_bloc.dart';

import 'package:cleanapp/services/authintication/presentaion/bloc/login/login_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/profile/profile_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/timer/timer_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/timer/timer_model.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerFactory(() => LoginBloc(loginUser: sl(), writeUserData: sl()));
  sl.registerFactory(() => VerifyBloc(
        verifyUser: sl(),
        readUserData: sl(),
        writeUserData: sl(),
      ));
  sl.registerFactory(() => TimerBloc(
      ticker: sl(),
      deleteStorage: sl(),
      readStorage: sl(),
      writeStorage: sl(),
      loginUser: sl()));
  sl.registerFactory(() => ProfileBLoc(readStorage: sl(), userInfo: sl()));
  sl.registerFactory(() => IFTBloc(isFirstTime: sl(), writeStorage: sl()));
  //usercases
  sl.registerLazySingleton(() => LoginUserUseCase(repo: sl()));
  sl.registerLazySingleton(() => WriteStorage(sl()));
  sl.registerLazySingleton(() => ReadStorage(sl()));
  sl.registerLazySingleton(() => VerifyUserUseCase(repo: sl()));
  sl.registerLazySingleton(() => getUserDetailsUseCase(repo: sl()));
  sl.registerLazySingleton(() => const Ticker());
  sl.registerLazySingleton(() => DeleteStorage(repo: sl()));
  sl.registerLazySingleton(() => IsFirstTime(repo: sl()));
  sl.registerFactory(() =>
      PasswordBloc(readStorage: sl(), writeStorage: sl(), loginUser: sl()));
  //repositories
  sl.registerLazySingleton<UserRepo>(() => UserRepoImplement(
      localDataSource: sl(), networkInfo: sl(), remoteDataSource: sl()));
  //datasources

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteImplWithHttp());
  sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(secureStorage: sl()));
  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //external
  final FlutterSecureStorage storage = FlutterSecureStorage();
  sl.registerLazySingleton(() => storage);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
