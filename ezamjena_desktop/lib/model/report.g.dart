// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report()
  ..proizvodId = (json['proizvodId'] as num?)?.toInt()
  ..prijavioKorisnikId = (json['prijavioKorisnikId'] as num?)?.toInt()
  ..razlog = json['razlog'] as String?
  ..poruka = json['poruka'] as String?
  ..datum =
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String)
  ..proizvodNaziv = json['proizvodNaziv'] as String?
  ..prijavioKorisnik = json['prijavioKorisnik'] as String?;

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'proizvodId': instance.proizvodId,
      'prijavioKorisnikId': instance.prijavioKorisnikId,
      'razlog': instance.razlog,
      'poruka': instance.poruka,
      'datum': instance.datum?.toIso8601String(),
      'proizvodNaziv': instance.proizvodNaziv,
      'prijavioKorisnik': instance.prijavioKorisnik,
    };
