// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..id = json['id'] as int?
  ..naziv = json['naziv'] as String?
  ..slika = json['slika'] as String?
  ..nazivKategorijeProizvoda = json['nazivKategorijeProizvoda'] as String?
  ..cijena = (json['cijena'] as num?)?.toDouble()
  ..nazivKorisnika = json['nazivKorisnika'] as String?
  ..stanjeNovo = json['stanjeNovo'] as bool?
  ..opis = json['opis'] as String?;

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'slika': instance.slika,
      'nazivKategorijeProizvoda': instance.nazivKategorijeProizvoda,
      'cijena': instance.cijena,
      'nazivKorisnika': instance.nazivKorisnika,
      'stanjeNovo': instance.stanjeNovo,
      'opis': instance.opis,
    };
