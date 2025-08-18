// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductNotification _$ProductNotificationFromJson(Map<String, dynamic> json) =>
    ProductNotification()
      ..korisnikId = (json['korisnikId'] as num?)?.toInt()
      ..proizvodId = (json['proizvodId'] as num?)?.toInt()
      ..poruka = json['poruka'] as String?
      ..vrijemeKreiranja = json['vrijemeKreiranja'] == null
          ? null
          : DateTime.parse(json['vrijemeKreiranja'] as String)
      ..proizvodNaziv = json['proizvodNaziv'] as String?;

Map<String, dynamic> _$ProductNotificationToJson(
        ProductNotification instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'proizvodId': instance.proizvodId,
      'poruka': instance.poruka,
      'vrijemeKreiranja': instance.vrijemeKreiranja?.toIso8601String(),
      'proizvodNaziv': instance.proizvodNaziv,
    };
