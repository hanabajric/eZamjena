import 'package:json_annotation/json_annotation.dart';
part 'buy.g.dart';

@JsonSerializable()
class Buy {
  DateTime? datum;
  int? proizvodId;
  int? korisnikId;
  double? cijena;
  String? nazivProizvoda;
  String? nazivKorisnika;

  Buy() {}

  factory Buy.fromJson(Map<String, dynamic> json) => _$BuyFromJson(json);

  /// Connect the generated [_$BuyToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BuyToJson(this);
}
