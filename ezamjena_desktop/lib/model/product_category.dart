import 'package:json_annotation/json_annotation.dart';

part 'product_category.g.dart';

@JsonSerializable()
class ProductCategory {
  int? id;
  String? naziv;

  ProductCategory() {}

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  /// Connect the generated [_$PProductCategoryToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}
