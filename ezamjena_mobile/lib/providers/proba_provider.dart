import '../model/proba.dart';
import 'base_provider.dart';

class ProbaProvider extends BaseProvider<Proba> {
  ProbaProvider() : super("Uloga");

  @override
  Proba fromJson(data) {
    // TODO: implement fromJson
    return Proba();
  }
}
