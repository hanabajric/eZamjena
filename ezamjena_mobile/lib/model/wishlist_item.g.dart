// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) => WishlistItem(
      id: (json['id'] as num).toInt(),
      listaZeljaId: (json['listaZeljaId'] as num).toInt(),
      proizvodId: (json['proizvodId'] as num).toInt(),
      vrijemeDodavanja: DateTime.parse(json['vrijemeDodavanja'] as String),
      proizvod: Product.fromJson(json['proizvod'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listaZeljaId': instance.listaZeljaId,
      'proizvodId': instance.proizvodId,
      'vrijemeDodavanja': instance.vrijemeDodavanja.toIso8601String(),
      'proizvod': instance.proizvod,
    };
