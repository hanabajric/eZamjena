import 'package:ezamjena_mobile/model/product_category.dart';
import 'package:ezamjena_mobile/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String? naziv;
  String? slika;
  String? nazivKategorijeProizvoda;
  double? cijena;
  String? nazivKorisnika;
  bool? stanjeNovo;
  String? opis;
  int? korisnikId;
  int? statusProizvodaId;
  int? kategorijaProizvodaId;
  ProductCategory? kategorijaProizvoda;
  User? korisnik;

  Product() {}

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Connect the generated [_$ProductToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
