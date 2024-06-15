import 'package:json_annotation/json_annotation.dart';
part 'rating.g.dart';

@JsonSerializable()
class Rating {
  DateTime? datum;
  int? ocjena1;
  int? proizvodId;
  int? korisnikId;

  Rating({
    required this.korisnikId,
    required this.proizvodId,
    required this.ocjena1,
    required this.datum,
  });

  factory Rating.fromJson(Map<String, dynamic> json) =>
      _$RatingFromJson(json);

  /// Connect the generated [_$RatingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}


