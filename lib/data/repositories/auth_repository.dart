import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart';


class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<UserModel> login(String email, String password) async {
    return await apiService.login(email, password);
  }
}
