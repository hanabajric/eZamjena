import 'package:ezamjena_desktop/model/report.dart';
import 'package:ezamjena_desktop/providers/base_provider.dart';

class ReportProvider extends BaseProvider<Report> {
  ReportProvider() : super("Prijava");

  @override
  Report fromJson(data) => Report.fromJson(data);

  void refreshReports() {
    notifyListeners();
  }
}
