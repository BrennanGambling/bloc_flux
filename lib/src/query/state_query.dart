library state_query;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'state_query.g.dart';

///Query the [StateBlocState] of a [StateBloc].
///
///[StateQuery]s can either be [single] or [subscription]. All [StateQuery]s
///result in the target [StateBloc] dispatching any number (including zero)
///of [BlocStateAction]s.
///
///## Single Mode
///{@template state_single_mode}
///For [single] [StateQuery]s the most recent [StateBlocState] of the requested 
///[StateBloc] will be provided once.
///{@endtemplate}
///
///## Subscription Mode
///{@template state_subscription_mode}
///For [subscription] [StateQuery]s the [StateBlocState] of the requested 
///[StateBloc] will be provided as it is updated.
///{@endtemplate}
abstract class StateQuery implements Built<StateQuery, StateQueryBuilder> {
  ///The [Bloc.key] of the [StateBloc] to query.
  String get blocKey;

  ///True if this [StateQuery] is a one time request.
  ///
  ///{@macro state_single_mode}
  ///
  ///[single] will always be the opposite of [subscription].
  bool get single;

  ///True if this [StateQuery] is canceling an equal [StateQuery].
  ///
  ///{@template equal_state_query}
  ///[StateQuery] are equal if every variable other than [cancel] are equal.
  ///{@endtemplate}
  @BuiltValueField(compare: false)
  bool get cancel;

  ///True if this [StateQuery] is a subscription.
  ///
  ///{@macro state_subscription_mode}
  ///
  ///[subscription] will always be the opposite of [single].
  @memoized
  bool get subscription => !single;

  ///@nodoc
  ///Internal constructor.
  ///
  ///{@macro state_single_and_cancel}
  StateQuery._();

  ///Instaniates a [StateQuery] for the [StateBloc] with [Bloc.key] equal to [blocKey].
  ///
  ///Be default this constructor returns a subscription [StateQuery] to instaniate
  ///a single [StateQuery] specifiy [single] as true (defaults to true).
  factory StateQuery(String blocKey, {single: false}) =>
      StateQuery.fromBuilder((b) => b
        ..blocKey = blocKey
        ..single = single
        ..cancel = false);

  ///Instantiates a [StateQuery] where [stateQuery.cancel] equals true.
  ///
  ///Use this to cancel [stateQuery]. The returned [StateQuery] must still be dispatched.
  ///
  ///[stateQuery] must not be a single [StateQuery]. That is [stateQuery.single]
  ///should equal [false], **otherwise an [ArgumentError] will be thrown.**
  factory StateQuery.cancel(StateQuery stateQuery) {
    if (stateQuery.single) {
      throw ArgumentError(
          "A StateQuery with single set to true cannot be canceled.");
    }
    return (stateQuery.toBuilder()..cancel = true).build();
  }

  ///Instaniates a [StateQuery] from a builder function.
  ///
  ///{@template state_single_and_cancel}
  ///[single] and [cancel] cannot both be true as only [subscription] [StateQuery]s
  ///can be cancelled.
  ///{@endtemplate}
  factory StateQuery.fromBuilder([updates(FieldIDBuilder)]) = _$StateQuery;

  ///The [Serializer] for this class.
  static Serializer<StateQuery> get serializer => _$stateQuerySerializer;
}
