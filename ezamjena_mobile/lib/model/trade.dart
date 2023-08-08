import 'package:json_annotation/json_annotation.dart';
part 'trade.g.dart';

@JsonSerializable()
class Trade {
  int? id;
  int? proizvod1Id;
  int? proizvod2Id;
  DateTime? datum;
  String? proizvod1Naziv;
  String? proizvod2Naziv;
  int? statusRazmjeneId;

  Trade() {}

  factory Trade.fromJson(Map<String, dynamic> json) => _$TradeFromJson(json);

  /// Connect the generated [_$TradeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TradeToJson(this);
}
