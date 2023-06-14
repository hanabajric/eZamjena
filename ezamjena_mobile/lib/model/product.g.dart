// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..id = json['id'] as int?
  ..naziv = json['naziv'] as String?
  ..slika = json['slika'] as String?
  ..kategorija = json['kategorija'] as String?
  ..cijena = (json['cijena'] as num?)?.toDouble()
  ..korisnickoIme = json['korisnickoIme'] as String?
  ..novo = json['novo'] as bool?
  ..opis = json['opis'] as String?;

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'slika': instance.slika,
      'kategorija': instance.kategorija,
      'cijena': instance.cijena,
      'korisnickoIme': instance.korisnickoIme,
      'novo': instance.novo,
      'opis': instance.opis,
    };
