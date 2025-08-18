import 'package:json_annotation/json_annotation.dart';
part 'product_notification.g.dart';

@JsonSerializable()
class ProductNotification {
  int? korisnikId;
  int? proizvodId;
  String? poruka;
  DateTime? vrijemeKreiranja;
  String? proizvodNaziv;

  ProductNotification();

  factory ProductNotification.fromJson(Map<String, dynamic> json) =>
      _$ProductNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$ProductNotificationToJson(this);
}
