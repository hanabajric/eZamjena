import 'package:ezamjena_desktop/model/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'product_category.dart';

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

  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  ProductCategory? kategorijaProizvoda;

  User? korisnik;

  Product() {}

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  static ProductCategory? _categoryFromJson(Map<String, dynamic> json) =>
      ProductCategory.fromJson(json);

  static Map<String, dynamic>? _categoryToJson(ProductCategory? category) =>
      category?.toJson();
}
