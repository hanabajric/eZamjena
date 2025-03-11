import 'package:json_annotation/json_annotation.dart';
import 'wishlist_item.dart';

part 'wishlist.g.dart';

@JsonSerializable()
class Wishlist {
  int id;
  int korisnikId;
  DateTime createdAt;

  Wishlist({
    required this.id,
    required this.korisnikId,
    required this.createdAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) =>
      _$WishlistFromJson(json);
  Map<String, dynamic> toJson() => _$WishlistToJson(this);
}
