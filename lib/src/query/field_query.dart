library field_query;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../field/field_id.dart';

part 'field_query.g.dart';

///This class represents a request to recieve updates when the value of any of
///the specified [Field]s change.
///
///[FieldQuery]s can be either [single] or [subscription]. All [FieldQuery]s
///result in the target [ValueBloc] dispatching any number (including zero)
///of [FieldValueAction]s.
///
///## Single Mode
///{@template field_single_mode}
///For [single] [FieldQuery]s the most recent value of the requested [Field]s will
///be provided once.
///{@endtemplate}
///
///## Subscription Mode
///{@template field_subscription_mode}
///For [subscription] [FieldQuery]s the values of the requested [Field]s will be
///be provided as they are updated.
///{@endtemplate}
@BuiltValue(nestedBuilders: false)
abstract class FieldQuery implements Built<FieldQuery, FieldQueryBuilder> {
  ///The [Serializer] for this class.
  static Serializer<FieldQuery> get serializer => _$fieldQuerySerializer;

  ///Instaniates a [FieldQuery].
  ///
  ///## Specific [Field]s
  ///To specify the [Field](s) to query specify **ONE** of the following [fieldIDs],
  ///[fieldKeys], [fieldID] or [fieldKey].
  ///
  ///{@macro only_one_id_param}
  ///
  ///{@macro keys_specified}
  ///
  ///{@macro ids_specified}
  ///
  ///## All [Field]s
  ///To query all of the [Field]s do not specify any of the ID ([fieldID(s)]) or
  ///Key ([fieldKey(s)]) parameters just the [blocKey].
  ///
  ///{@macro all_null}
  ///
  ///## One Time Request
  ///If this query is a one time request set [single] to true (defaults to false).
  factory FieldQuery(
          {String blocKey,
          BuiltList<FieldID> fieldIDs,
          BuiltList<String> fieldKeys,
          FieldID fieldID,
          String fieldKey,
          single: false}) =>
      FieldQuery.fromBuilder((builder) {
        final bool fieldIDsNull = fieldIDs == null;
        final bool fieldKeysNull = fieldKeys == null;
        final bool fieldIDNull = fieldID == null;
        final bool fieldKeyNull = fieldKey == null;

        _parameterChecks(blocKey, fieldIDs, fieldKeys, fieldID, fieldKey);

        if (!fieldIDsNull) {
          builder.fieldIDs = BuiltList(fieldIDs);
        } else if (!fieldKeysNull) {
          builder.fieldIDs =
              BuiltList(fieldKeys.map((key) => FieldID(blocKey, key)));
        } else if (!fieldIDNull) {
          builder.fieldIDs = (ListBuilder()..add(fieldID)).build();
        } else if (!fieldKeyNull) {
          builder.fieldIDs =
              (ListBuilder()..add(FieldID(blocKey, fieldKey))).build();
        }

        builder
          ..single = single
          ..cancel = false;
      });

  ///Instantiates a [FieldQuery] where [fieldQuery.cancel] equals true.
  ///
  ///Use this to cancel [fieldQuery]. The returned [FieldQuery] must still be dispatched.
  ///
  ///[fieldQuery] must not be a single [FieldQuery]. That is [fieldQuery.single]
  ///should equal false, **otherwise an ArgumentError will be thrown.**
  factory FieldQuery.cancelQuery(FieldQuery fieldQuery) {
    if (fieldQuery.single) {
      throw ArgumentError(
          "A FieldQuery with single set to true cannot be canceled.");
    }
    return (fieldQuery.toBuilder()..cancel = true).build();
  }

  ///Instantiates a [FieldQuery] from builder function.
  ///
  ///{@macro field_single_and_cancel}
  ///
  ///{@macro ids_blocKey_equal}
  factory FieldQuery.fromBuilder([updates(FieldQueryBuilder b)]) = _$FieldQuery;

  ///@ndoc
  ///Internal constructor.
  ///
  ///{@macro field_single_and_cancel}
  ///
  ///{@macro ids_blocKey_equal}
  FieldQuery._() {
    _internalParameterChecks(single, cancel, blocKey, fieldIDs);
  }

  ///True if this [FieldQuery] is for all [Field]s in the specified [ValueBloc].
  @memoized
  bool get all => fieldIDs == null;

  ///The [key] of the [ValueBloc] containing the specified [Field]s.
  String get blocKey;

  ///True if this [FieldQuery] is canceling an equal [FieldQuery].
  ///
  ///{@template equal_field_query}
  ///[FieldQuery] are equal if every variable other than [cancel] are equal.
  ///{@endtemplate}
  @BuiltValueField(compare: false)
  bool get cancel;

  ///The [FieldID]s for the [Field]s that should be queried.
  @nullable
  BuiltList<FieldID> get fieldIDs;

  ///The keys provided to the [Field] constructor for the [Field]s that should
  ///be queried.
  @memoized
  @nullable
  BuiltList<String> get fieldKeys => fieldIDs?.map((id) => id.fieldKey);

  ///True if this [FieldQuery] is a one time request.
  ///
  ///{@macro field_single_mode}
  ///
  ///[single] will always be the opposite of [subscription].
  bool get single;

  ///True if this [FieldQuery] is a subscription.
  ///
  ///{@macro field_subscription_mode}
  ///
  ///[subscription] will always be the opposite of [single].
  @memoized
  bool get subscription => !single;

  ///@nodoc
  ///Performs checks of fieldIDs parameter.
  ///
  ///{@template ids_specified}
  ///If [fieldIDs] is specified the [FieldID.blocKey] for each element must be
  ///the same, **otherwise an ArgumentError will be thrown.**
  ///{@endtemplate}
  static void _fieldIDsCheck(BuiltList<FieldID> fieldIDs) {
    if (fieldIDs != null) {
      if (!fieldIDs.every((id) => id.blocKey == fieldIDs.first.blocKey)) {
        throw ArgumentError(
            "If fieldIDs is specified the blocKey for each of the elements must be equal.");
      }
    }
  }

  ///@nodoc
  ///Performs checks when the internal constructor is called.
  ///
  ///{@template field_single_and_cancel}
  ///[single] and [cancel] cannot both be true as only [subscription] [FieldQuery]s
  ///can be cancelled.
  ///{@endtemplate}
  ///
  ///{@template ids_blocKey_equal}
  ///The [FieldID.blocKey] of each element in [fieldIDs] must be equal to [blocKey].
  ///{@endtemplate}
  static void _internalParameterChecks(
      bool single, bool cancel, String blocKey, BuiltList<FieldID> fieldIDs) {
    if (single && cancel) {
      throw StateError(
          "single and cancel cannot both be true as only subscriptions can be canceld.");
    }

    if (fieldIDs != null) {
      if (!fieldIDs.every((id) => id.blocKey == blocKey)) {
        throw StateError(
            "The FieldID.blocKey of each element in fieldIDs must be equal to blocKey.");
      }
    }
  }

  ///@nodoc
  ///Performs checks on constructor parameters.
  ///
  ///{@template only_one_id_param}
  ///Only specify **ONE** of the following parameters:
  ///  1. [fieldIDs]
  ///  2. [fieldKeys]
  ///  3. [fieldID]
  ///  4. [fieldKey]
  ///**If more than one of theses parameters are specified an ArgumentError
  ///will be thrown.**
  ///{@endtemplate}
  ///
  ///{@template keys_specified}
  ///If [fieldKey] or [fieldKeys] is specified [blocKey] **MUST** also be specified,
  ///**otherwise an ArgumentError will be thrown.**
  ///{@endtemplate}
  ///
  ///{@template all_null}
  ///If none of the ID ([fieldID(s)]) or Key ([fieldKey(s)]) are specified the
  ///[blocKey] **MUST** be specified, **otherwise an ArgumentError will be thrown.**
  ///{@endtemplate}
  ///
  ///{@macro ids_specified}
  static void _parameterChecks(String blocKey, BuiltList<FieldID> fieldIDs,
      BuiltList<String> fieldKeys, FieldID fieldID, String fieldKey) {
    final bool blocKeyNull = blocKey == null;
    final bool fieldIDsNull = fieldIDs == null;
    final bool fieldKeysNull = fieldKeys == null;
    final bool fieldIDNull = fieldID == null;
    final bool fieldKeyNull = fieldKey == null;

    int nonNullFields = 0;
    nonNullFields += fieldIDsNull ? 0 : 1;
    nonNullFields += fieldKeysNull ? 0 : 1;
    nonNullFields += fieldIDNull ? 0 : 1;
    nonNullFields += fieldKeyNull ? 0 : 1;

    if (nonNullFields == 0) {
      if (blocKeyNull) {
        throw ArgumentError(
            "If none of the ID or Key parameters are specified blocKey must be.");
      }
    } else if (nonNullFields > 1) {
      throw ArgumentError(
          "Only one of fieldIDs, fieldKeys, fieldID or fieldKey may be specified.");
    }

    if (!fieldKeyNull || !fieldKeysNull) {
      if (blocKeyNull) {
        throw ArgumentError(
            "If fieldKey or fieldKeys is specified blocKey must also be specified.");
      }
    }

    _fieldIDsCheck(fieldIDs);
  }
}
