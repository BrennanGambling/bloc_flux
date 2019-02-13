library field_id;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'field_id.g.dart';

///A unique identifer for a [Field]/[FieldImpl].
///
///It specifies both the key from the [Bloc]/[BlocImpl] ([blocKey]) and the key
///from the [Field]/[FieldImpl] ([fieldKey]).
///
///{@template field_id_blocKey}
///[blocKey] must not be null.
///{@endtemplate}
///
///{@template field_id_fieldKey}
///[fieldKey] must not be null.
///{@endtemplate}
abstract class FieldID implements Built<FieldID, FieldIDBuilder> {
  ///The [Serializer] for this class.
  static Serializer<FieldID> get serializer => _$fieldIDSerializer;

  ///Instaniates a [FieldID] for the [Field] with key [fieldKey] and the [Bloc]
  ///with key [blocKey].
  ///
  ///{@macro field_id_blocKey}
  ///
  ///{@macro field_id_fieldKey}
  factory FieldID(String blocKey, String fieldKey) =>
      FieldID.fromBuilder((b) => b
        ..blocKey = blocKey
        ..fieldKey = fieldKey);

  factory FieldID.fromBuilder([updates(FieldIDBuilder)]) = _$FieldID;

  ///@nodoc
  ///Internal constructor.
  FieldID._();

  ///The key from the [Bloc]/[BlocImpl].
  ///
  ///{@macro field_id_blocKey}
  String get blocKey;

  ///The key from the [Field]/[FieldImpl].
  ///
  ///{@macro field_id_fieldKey}
  String get fieldKey;
}
