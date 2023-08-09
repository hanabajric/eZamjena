// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trade _$TradeFromJson(Map<String, dynamic> json) => Trade()
  ..id = json['id'] as int?
  ..proizvod1Id = json['proizvod1Id'] as int?
  ..proizvod2Id = json['proizvod2Id'] as int?
  ..korisnik1Id = json['korisnik1Id'] as int?
  ..korisnik2Id = json['korisnik2Id'] as int?
  ..datum =
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String)
  ..proizvod1Naziv = json['proizvod1Naziv'] as String?
  ..proizvod2Naziv = json['proizvod2Naziv'] as String?
  ..statusRazmjeneId = json['statusRazmjeneId'] as int?;

Map<String, dynamic> _$TradeToJson(Trade instance) => <String, dynamic>{
      'id': instance.id,
      'proizvod1Id': instance.proizvod1Id,
      'proizvod2Id': instance.proizvod2Id,
      'korisnik1Id': instance.korisnik1Id,
      'korisnik2Id': instance.korisnik2Id,
      'datum': instance.datum?.toIso8601String(),
      'proizvod1Naziv': instance.proizvod1Naziv,
      'proizvod2Naziv': instance.proizvod2Naziv,
      'statusRazmjeneId': instance.statusRazmjeneId,
    };
