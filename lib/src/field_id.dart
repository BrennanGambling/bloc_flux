library field_query;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'field_id.g.dart';

abstract class FieldID implements Built<FieldID, FieldIDBuilder> {
  String get blocKey;

  String get fieldKey;

  FieldID._();

  factory FieldID(String blocKey, String fieldKey) =>
      FieldID.fromBuilder((b) => b
        ..blocKey = blocKey
        ..fieldKey = fieldKey);
  factory FieldID.fromBuilder([updates(FieldIDBuilder)]) = _$FieldID;

  static Serializer<FieldID> get serializer => _$fieldIDSerializer;
}
