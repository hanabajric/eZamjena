// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trade _$TradeFromJson(Map<String, dynamic> json) => Trade()
  ..id = json['id'] as int?
  ..datum =
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String)
  ..proizvod1Id = json['proizvod1Id'] as int?
  ..proizvod2Id = json['proizvod2Id'] as int?
  ..statusRazmjeneId = json['statusRazmjeneId'] as int?;

Map<String, dynamic> _$TradeToJson(Trade instance) => <String, dynamic>{
      'id': instance.id,
      'datum': instance.datum?.toIso8601String(),
      'proizvod1Id': instance.proizvod1Id,
      'proizvod2Id': instance.proizvod2Id,
      'statusRazmjeneId': instance.statusRazmjeneId,
    };
