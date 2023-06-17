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

  Product() {}

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Connect the generated [_$ProductToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
