import '../model/user.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("Korisnik");

  @override
  User fromJson(data) {
    // TODO: implement fromJson
    return User();
  }
}