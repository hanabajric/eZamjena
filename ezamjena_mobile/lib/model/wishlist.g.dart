// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wishlist _$WishlistFromJson(Map<String, dynamic> json) => Wishlist(
      id: (json['id'] as num).toInt(),
      korisnikId: (json['korisnikId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WishlistToJson(Wishlist instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
