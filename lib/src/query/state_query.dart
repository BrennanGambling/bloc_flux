library state_query;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'state_query.g.dart';

///Query the [BlocState] of a StateBloc.
abstract class StateQuery implements Built<StateQuery, StateQueryBuilder> {
  String get blocKey;

  bool get single;

  @BuiltValueField(compare: false)
  bool get cancel;

  ///Indicates this FieldQuery is a subscription.
  @memoized
  bool get subscription => !single;

  StateQuery._();

  factory StateQuery(String blocKey, {single: false, cancel: false}) =>
      StateQuery.fromBuilder((b) => b
        ..blocKey = blocKey
        ..single = single
        ..cancel = cancel);
  factory StateQuery.fromBuilder([updates(FieldIDBuilder)]) = _$StateQuery;

  static Serializer<StateQuery> get serializer => _$stateQuerySerializer;
}
