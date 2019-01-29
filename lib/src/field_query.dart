library field_query;

import 'field_id.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'field_query.g.dart';

///This class represents a request to recieve updates for any number of Fields
///for a specified bloc.
///
///FieldQuery's can be either single or subscription.
///For single FieldQuery's the requested fields will be provided once.
///For subscription FieldQuery's the requested fields will be provided when they
///change until the subscription is cancelled.
///
///[fields] is an
@BuiltValue(nestedBuilders: false)
abstract class FieldQuery implements Built<FieldQuery, FieldQueryBuilder> {
  ///Indicates this FieldQuery is a one time request.
  bool get single;

  @memoized
  bool get all => fieldKeys == null;

  @BuiltValueField(compare: false)
  bool get cancel;

  ///Indicates this FieldQuery is a subscription.
  @memoized
  bool get subscription => !single;

  @memoized
  BuiltList<FieldID> get fieldIDs {
    ListBuilder listBuilder = ListBuilder();
    fieldKeys.forEach((key) => FieldID(blocKey, key));
    return listBuilder.build();
  }

  ///The key of the bloc containing the specified fields.
  String get blocKey;

  ///The fields to request or null for all fields.
  @nullable
  BuiltList<String> get fieldKeys;

  FieldQuery._();

  factory FieldQuery(String blocKey,
          {BuiltList<String> fieldKeys,
          List<String> fieldKeysList,
          single: false,
          cancel: false}) =>
      FieldQuery.fromBuilder((builder) {
        final bool builtListNull = fieldKeys == null;
        final bool listNull = fieldKeys == null;
        //if builtListNull and listNull are both false
        if (!(builtListNull || listNull)) {
          throw ArgumentError(
              "only fieldKeys or fieldKeysList may be specified. Not both.");
        }

        builder
          ..blocKey = blocKey
          ..fieldKeys = fieldKeys ?? fieldKeysList
          ..single = single
          ..cancel = cancel;
      });

  factory FieldQuery.cancel(FieldQuery fieldQuery) =>
      FieldQuery.fromBuilder((b) => b..cancel = true);

  factory FieldQuery.fromBuilder([updates(FieldQueryBuilder b)]) = _$FieldQuery;

  static Serializer<FieldQuery> get serializer => _$fieldQuerySerializer;
}
