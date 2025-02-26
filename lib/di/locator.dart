import 'package:get_it/get_it.dart';
import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/constants/environment.dart';
import 'package:vizinhanca_shop/data/repositories/address_repository.dart';
import 'package:vizinhanca_shop/data/repositories/product_repository.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/data/services/local_storage_service.dart';
import 'package:vizinhanca_shop/data/services/location_service.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/product/viewmodels/product_view_model.dart';
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
    () => AuthServiceImpl(localStorageService: locator<LocalStorageService>()),
  );
  locator.registerLazySingleton<LocationService>(() => LocationServiceImpl());

  // Repositories
  locator.registerLazySingleton<AddressRepository>(
    () => AddressRepository(client: locator<HttpClient>()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      client: locator<HttpClient>(),
      appConfig: locator<AppConfig>(),
    ),
  );

  // ViewModels
  locator.registerLazySingleton<AddressViewModel>(
    () => AddressViewModel(
      repository: locator<AddressRepository>(),
      locationService: locator<LocationService>(),
    ),
  );
  locator.registerLazySingleton<ProductViewModel>(
    () => ProductViewModel(repository: locator<ProductRepository>()),
  );
}
