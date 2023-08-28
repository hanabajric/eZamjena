// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as int?
  ..korisnickoIme = json['korisnickoIme'] as String?
  ..ime = json['ime'] as String?
  ..prezime = json['prezime'] as String?
  ..slika = json['slika'] as String?
  ..telefon = json['telefon'] as String?
  ..email = json['email'] as String?
  ..brojKupovina = json['brojKupovina'] as int?
  ..brojRazmjena = json['brojRazmjena'] as int?
  ..brojAktivnihArtikala = json['brojAktivnihArtikala'] as int?
  ..adresa = json['adresa'] as String?
  ..nazivGrada = json['nazivGrada'] as String?
  ..password = json['password'] as String?
  ..passwordPotvrda = json['password'] as String?
  ..gradId = json['gradId'] as int?
  ..ulogaId = json['ulogaId'] as int?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'korisnickoIme': instance.korisnickoIme,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'slika': instance.slika,
      'telefon': instance.telefon,
      'email': instance.email,
      'brojKupovina': instance.brojKupovina,
      'brojRazmjena': instance.brojRazmjena,
      'brojAktivnihArtikala': instance.brojAktivnihArtikala,
      'adresa': instance.adresa,
      'nazivGrada': instance.nazivGrada,
      'password': instance.password,
      'passwordPotvrda': instance.passwordPotvrda,
      'gradId': instance.gradId,
      'ulogaId': instance.ulogaId,
    };
