import 'package:ezamjena_desktop/model/product.dart';
import 'package:json_annotation/json_annotation.dart';
part 'trade.g.dart';

@JsonSerializable()
class Trade {
  int? id;
  int? proizvod1Id;
  int? proizvod2Id;
  int? korisnik1Id;
  int? korisnik2Id;
  DateTime? datum;
  String? proizvod1Naziv;
  String? proizvod2Naziv;
  String? korisnik1;
  String? korisnik2;
  int? statusRazmjeneId;

  Product? proizvod1; // Dodano
  Product? proizvod2; // Dodano
  Trade() {}

  factory Trade.fromJson(Map<String, dynamic> json) => _$TradeFromJson(json);

  /// Connect the generated [_$TradeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TradeToJson(this);
}
