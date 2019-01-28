library field_query;

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

  ///Indicates this FieldQuery is a subscription.
  @memoized
  bool get subscription => !single;

  ///The key of the bloc containing the specified fields.
  String get blocKey;

  ///The fields to request or null for all fields.
  @nullable
  BuiltList<String> get fieldKeys;

  FieldQuery._();

  factory FieldQuery(String blocKey,
          {BuiltList<String> fieldKeys,
          single: false}) =>
      FieldQuery.fromBuilder((b) => b
        ..blocKey = blocKey
        ..fieldKeys = fieldKeys
        ..single = single);

  factory FieldQuery.fromMap(String blocKey,
          {List<String> fieldKeys,
          single: false}) =>
      FieldQuery(blocKey,
          fieldKeys: BuiltList<String>(fieldKeys),
          single: single);

  factory FieldQuery.fromBuilder([updates(FieldQueryBuilder b)]) = _$FieldQuery;

  static Serializer<FieldQuery> get serializer => _$fieldQuerySerializer;
}
