import 'package:json_annotation/json_annotation.dart';
part 'report.g.dart';

@JsonSerializable()
class Report {
  int? proizvodId;
  int? prijavioKorisnikId;
  String? razlog;
  String? poruka;
  DateTime? datum;

  Report() {}

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  /// Connect the generated [_$ReportToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
