import 'dart:convert';

import 'package:bus_tracking_app/enums/place_prediction_type.dart';
import 'package:bus_tracking_app/utils/enum_string.dart';

class PlacePrediction {
  String? description;
  List<MatchedSubstring>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<PlacePredictionType>? types;

  PlacePrediction(
      {this.description,
      this.matchedSubstrings,
      this.placeId,
      this.reference,
      this.structuredFormatting,
      this.terms,
      this.types});

  PlacePrediction copyWith(
      String? description,
      List<MatchedSubstring>? matchedSubstrings,
      String? placeId,
      String? reference,
      StructuredFormatting? structuredFormatting,
      List<Term>? terms,
      List<PlacePredictionType>? types) {
    return PlacePrediction(
        description: description ?? this.description,
        matchedSubstrings: matchedSubstrings ?? this.matchedSubstrings,
        placeId: placeId ?? this.placeId,
        reference: reference ?? this.reference,
        structuredFormatting: structuredFormatting ?? this.structuredFormatting,
        terms: terms ?? this.terms,
        types: types ?? this.types);
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'matched_substrings': matchedSubstrings != null
          ? matchedSubstrings!.map((e) => e.toMap()).toList()
          : null,
      'place_id': placeId,
      'reference': reference,
      'structured_formatting':
          structuredFormatting != null ? structuredFormatting!.toMap() : null,
      'terms': terms != null ? terms!.map((e) => e.toMap()).toList() : null,
      'types': types != null
          ? types!.map((e) => EnumString.convertToString(e)).toList()
          : null
    }..removeWhere((key, value) => value == null);
  }

  factory PlacePrediction.fromMap(Map<String, dynamic> map) {
    return PlacePrediction(
        description: map['description'],
        matchedSubstrings: map['matched_substrings'] != null
            ? List<MatchedSubstring>.from(map['matched_substrings']
                .map((e) => MatchedSubstring.fromMap(e)))
            : <MatchedSubstring>[],
        placeId: map['place_id'],
        reference: map['reference'],
        structuredFormatting: map['structured_formatting'] != null
            ? StructuredFormatting.fromMap(map['structured_formatting'])
            : null,
        terms: map['terms'] != null
            ? List<Term>.from(map['terms'].map((e) => Term.fromMap(e)))
            : <Term>[],
        /*types: map['types'] != null
            ? List<PlacePredictionType>.from(map['types'].map((e) =>
                EnumString.convertFromString(PlacePredictionType.values, e)))
            : <PlacePredictionType>[]*/);
  }
}

class MatchedSubstring {
  int? length;
  int? offset;

  MatchedSubstring({this.length, this.offset});

  MatchedSubstring copyWith(int? length, int? offset) {
    return MatchedSubstring(
        length: length ?? this.length, offset: offset ?? this.offset);
  }

  Map<String, dynamic> toMap() {
    return {'length': length, 'offset': offset}
      ..removeWhere((key, value) => value == null);
  }

  factory MatchedSubstring.fromMap(Map<String, dynamic> map) {
    return MatchedSubstring(length: map['length'], offset: map['offset']);
  }

  String toJson() => json.encode(toMap());

  factory MatchedSubstring.fromJson(String source) =>
      MatchedSubstring.fromMap(json.decode(source));
}

class StructuredFormatting {
  String? mainText;
  List<MatchedSubstring>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting(
      {this.mainText, this.mainTextMatchedSubstrings, this.secondaryText});

  StructuredFormatting copyWith(
      String? mainText,
      List<MatchedSubstring>? mainTextMatchedSubstrings,
      String? secondaryText) {
    return StructuredFormatting(
        mainText: mainText ?? this.mainText,
        mainTextMatchedSubstrings:
            mainTextMatchedSubstrings ?? this.mainTextMatchedSubstrings,
        secondaryText: secondaryText ?? this.secondaryText);
  }

  Map<String, dynamic> toMap() {
    return {
      'main_text': mainText,
      'main_text_matched_substrings': mainTextMatchedSubstrings != null
          ? mainTextMatchedSubstrings!.map((e) => e.toMap()).toList()
          : null,
      'secondary_text': secondaryText
    }..removeWhere((key, value) => value == null);
  }

  factory StructuredFormatting.fromMap(Map<String, dynamic> map) {
    return StructuredFormatting(
        mainText: map['main_text'],
        mainTextMatchedSubstrings: map['main_text_matched_substrings'] != null
            ? List<MatchedSubstring>.from(map['main_text_matched_substrings']
                .map((e) => MatchedSubstring.fromMap(e)))
            : <MatchedSubstring>[],
        secondaryText: map['secondary_text']);
  }

  String toJson() => json.encode(toMap());

  factory StructuredFormatting.fromJson(String source) =>
      StructuredFormatting.fromMap(json.decode(source));
}

class Term {
  int? offset;
  String? value;

  Term({this.offset, this.value});

  Term copyWith(int? offset, String? value) {
    return Term(offset: offset ?? this.offset, value: value ?? this.value);
  }

  Map<String, dynamic> toMap() {
    return {'offset': offset, 'value': value}
      ..removeWhere((key, value) => value == null);
  }

  factory Term.fromMap(Map<String, dynamic> map) {
    return Term(offset: map['offset'], value: map['value']);
  }

  String toJson() => json.encode(toMap());

  factory Term.fromJson(String source) => Term.fromMap(json.decode(source));
}
