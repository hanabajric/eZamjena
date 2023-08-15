import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? korisnickoIme;
  String? ime;
  String? prezime;
  String? slika;
  String? telefon;
  String? email;
  int? brojKupovina;
  int? brojRazmjena;
  int? brojAktivnihArtikala;
  String? adresa;
  String? nazivGrada;
  String? password;
  int? ulogaId;
  int? gradId;

  User() {}

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
