// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = (json['id'] as num?)?.toInt()
  ..korisnickoIme = json['korisnickoIme'] as String?
  ..ime = json['ime'] as String?
  ..prezime = json['prezime'] as String?
  ..slika = json['slika'] as String?
  ..telefon = json['telefon'] as String?
  ..email = json['email'] as String?
  ..brojKupovina = (json['brojKupovina'] as num?)?.toInt()
  ..brojRazmjena = (json['brojRazmjena'] as num?)?.toInt()
  ..brojAktivnihArtikala = (json['brojAktivnihArtikala'] as num?)?.toInt()
  ..adresa = json['adresa'] as String?
  ..nazivGrada = json['nazivGrada'] as String?
  ..password = json['password'] as String?
  ..passwordPotvrda = json['passwordPotvrda'] as String?
  ..gradId = (json['gradId'] as num?)?.toInt()
  ..ulogaId = (json['ulogaId'] as num?)?.toInt();

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
