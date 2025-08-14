import '../model/report.dart';
import 'base_provider.dart';

class ReportProvider extends BaseProvider<Report> {
  ReportProvider() : super("Prijava");

  @override
  Report fromJson(data) => Report.fromJson(data);
}
