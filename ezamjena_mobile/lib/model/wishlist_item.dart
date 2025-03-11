import 'package:ezamjena_mobile/model/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wishlist_item.g.dart';

@JsonSerializable()
class WishlistItem {
  int id;
  int listaZeljaId;
  int proizvodId;
  DateTime vrijemeDodavanja;
  Product proizvod;

  WishlistItem(
      {required this.id,
      required this.listaZeljaId,
      required this.proizvodId,
      required this.vrijemeDodavanja,
      required this.proizvod});

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);

  /// Connect the generated [_$WishlistItemToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$WishlistItemToJson(this);
}
