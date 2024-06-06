// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Buy _$BuyFromJson(Map<String, dynamic> json) => Buy()
  ..datum =
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String)
  ..proizvodId = (json['proizvodId'] as num?)?.toInt()
  ..korisnikId = (json['korisnikId'] as num?)?.toInt();

Map<String, dynamic> _$BuyToJson(Buy instance) => <String, dynamic>{
      'datum': instance.datum?.toIso8601String(),
      'proizvodId': instance.proizvodId,
      'korisnikId': instance.korisnikId,
    };
