import 'package:get_it/get_it.dart';
import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/constants/environment.dart';
import 'package:vizinhanca_shop/data/repositories/address_repository.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';
import 'package:vizinhanca_shop/data/repositories/login_repository.dart';
import 'package:vizinhanca_shop/data/repositories/profile_repository.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/data/services/local_storage_service.dart';
import 'package:vizinhanca_shop/data/services/location_service.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/login/viewmodels/login_view_model.dart';
import 'package:vizinhanca_shop/features/menu/viewmodels/menu_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/main/viewmodels/main_view_model.dart';
import 'package:vizinhanca_shop/features/announcement/viewmodels/announcement_view_model.dart';
import 'package:vizinhanca_shop/features/profile/viewmodels/profile_view_model.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Config
  locator.registerSingleton<AppConfig>(AppConfig(baseUrl: Environment.baseUrl));

  // Client
  locator.registerLazySingleton<HttpClient>(() => HttpClientImpl());

  // Services
  locator.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(),
  );
  locator.registerLazySingleton<AuthService>(
    () => AuthService(localStorageService: locator<LocalStorageService>()),
  );
  locator.registerLazySingleton<LocationService>(() => LocationServiceImpl());

  // Repositories
  locator.registerLazySingleton<AddressRepository>(
    () => AddressRepository(client: locator<HttpClient>()),
  );
  locator.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepository(
      client: locator<HttpClient>(),
      appConfig: locator<AppConfig>(),
      localStorageService: locator<LocalStorageService>(),
      locationService: locator<LocationService>(),
    ),
  );
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(
      client: locator<HttpClient>(),
      appConfig: locator<AppConfig>(),
      localStorageService: locator<LocalStorageService>(),
    ),
  );
  locator.registerLazySingleton<LoginRepository>(
    () => LoginRepository(
      client: locator<HttpClient>(),
      appConfig: locator<AppConfig>(),
      localStorageService: locator<LocalStorageService>(),
    ),
  );

  // ViewModels
  locator.registerLazySingleton<LoginViewModel>(
    () => LoginViewModel(
      loginRepository: locator<LoginRepository>(),
      authService: locator<AuthService>(),
      mainViewModel: locator<MainViewModel>(),
    ),
  );
  locator.registerLazySingleton<AddressViewModel>(
    () => AddressViewModel(
      repository: locator<AddressRepository>(),
      locationService: locator<LocationService>(),
    ),
  );
  locator.registerLazySingleton<HomeViewModel>(
    () => HomeViewModel(
      repository: locator<AnnouncementRepository>(),
      addressViewModel: locator<AddressViewModel>(),
    ),
  );
  locator.registerLazySingleton<AnnouncementViewModel>(
    () => AnnouncementViewModel(repository: locator<AnnouncementRepository>()),
  );
  locator.registerLazySingleton<MainViewModel>(() => MainViewModel());
  locator.registerLazySingleton<MyAnnouncementsViewModel>(
    () => MyAnnouncementsViewModel(
      repository: locator<AnnouncementRepository>(),
      addressRepository: locator<AddressRepository>(),
    ),
  );
  locator.registerLazySingleton<ProfileViewModel>(
    () => ProfileViewModel(repository: locator<ProfileRepository>()),
  );
  locator.registerLazySingleton<MenuViewModel>(
    () => MenuViewModel(repository: locator<ProfileRepository>()),
  );
}
