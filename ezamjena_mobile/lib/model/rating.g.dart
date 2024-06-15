// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      proizvodId: (json['proizvodId'] as num?)?.toInt(),
      ocjena1: (json['ocjena1'] as num?)?.toInt(),
      datum: json['datum'] == null
          ? null
          : DateTime.parse(json['datum'] as String),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'datum': instance.datum?.toIso8601String(),
      'ocjena1': instance.ocjena1,
      'proizvodId': instance.proizvodId,
      'korisnikId': instance.korisnikId,
    };
