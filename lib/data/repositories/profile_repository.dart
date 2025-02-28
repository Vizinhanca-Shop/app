import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

class ProfileRepository {
  final HttpClient client;
  final AppConfig appConfig;

  ProfileRepository({required this.client, required this.appConfig});

  String get baseUrl => appConfig.baseUrl;

  Future<UserModel> fetchUserById({required String userId}) async {
    await Future.delayed(Duration(seconds: 2));

    return UserModel(
      id: '1',
      name: 'John Doe',
      phone: '48984848484',
      avatar: 'https://via.placeholder.com/150',
    );
  }

  Future<bool> deleteUser({required String userId}) async {
    await Future.delayed(Duration(seconds: 2));

    return true;
  }
}
