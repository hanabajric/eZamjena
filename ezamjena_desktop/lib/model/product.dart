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

  @JsonKey(fromJson: _userFromJson, toJson: _userToJson)
  User? korisnik;

  Product();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  static ProductCategory? _categoryFromJson(Map<String, dynamic>? json) =>
      json == null ? null : ProductCategory.fromJson(json);

  static Map<String, dynamic>? _categoryToJson(ProductCategory? category) =>
      category?.toJson();

  static User? _userFromJson(Map<String, dynamic>? json) =>
      json == null ? null : User.fromJson(json);

  static Map<String, dynamic>? _userToJson(User? user) => user?.toJson();
}
