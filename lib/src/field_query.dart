library field_query;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'field_query.g.dart';

typedef UriTransformer = Uri Function(Uri uri);

@BuiltValue(nestedBuilders: false)
abstract class FieldQuery implements Built<FieldQuery, FieldQueryBuilder> {
  static const String blocQueryScheme = "blocquery";
  static const String fieldQueryScheme = "fieldquery";

  static const String fieldAttribute = "field";
  static const String dataAttribute = "data";

  Uri get blocUri;

  BuiltList<Uri> get fieldUris;

  FieldQuery._();
  factory FieldQuery(
      String blocKey, BuiltListMultimap<String, String> fieldQuery) {
    BuiltList<String> fieldKeys = BuiltList(fieldQuery.keys);

    //TODO: clean this up. maybe move the individual variable creation operations into there own static methods.

    //the key is a query type and the value is a list of query params for that type.
    Map<String, List<String>> blocQueryParams = Map();
    blocQueryParams[fieldAttribute] = fieldKeys.toList();

    Uri blocUri = Uri(
        scheme: blocQueryScheme,
        pathSegments: [blocKey],
        queryParameters: blocQueryParams);

    ListBuilder<Uri> fieldUrisBuilder = ListBuilder();
    fieldQuery.forEachKey((key, data) {
      //the key is a query type and the value is a list of query params for that type.
      Map<String, List<String>> queryParams = Map();
      queryParams[dataAttribute] = data.toList();

      Uri uri = Uri(
          scheme: fieldQueryScheme,
          pathSegments: [blocKey, key],
          queryParameters: queryParams);

      fieldUrisBuilder.add(uri);
    });
    BuiltList fieldUris = fieldUrisBuilder.build();

    return FieldQuery.fromBuilder((b) => b
      ..blocUri = blocUri
      ..fieldUris = fieldUris);
  }

  factory FieldQuery.fromMap(
          String blocKey, Map<String, List<String>> fieldQuery) =>
      FieldQuery(blocKey, BuiltListMultimap<String, String>(fieldQuery));

  factory FieldQuery.fromBuilder([updates(FieldQueryBuilder b)]) = _$FieldQuery;

  static Serializer<FieldQuery> get serializer => _$fieldQuerySerializer;
}
