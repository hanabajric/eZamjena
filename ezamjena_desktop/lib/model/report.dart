import 'package:json_annotation/json_annotation.dart';
part 'report.g.dart';

@JsonSerializable()
class Report {
  int? proizvodId;
  int? prijavioKorisnikId;
  String? razlog;
  String? poruka;
  DateTime? datum;

  String? proizvodNaziv;
  String? prijavioKorisnik;

  Report();

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
