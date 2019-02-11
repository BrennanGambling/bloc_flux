library field_state;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';

import '../field_id.dart';
import '../serializers.dart';

part 'field_state.g.dart';

/*TODO: make sure the changing of data field to nullable does not have
any unintended side effects. This was done because the state of some 
state fields will be mull if an initial state is not given.*/

///Wraps the last output of the [StateField] with [StateField.fieldID] equal
///to [fieldID].
///
///[data] may be null.
///
///[fieldID] **MUST NOT** be null.
@BuiltValue(nestedBuilders: false)
abstract class FieldState<T>
    implements Built<FieldState<T>, FieldStateBuilder<T>> {
  ///The [Serializer] for this class.
  static Serializer<FieldState> get serializer => _$fieldStateSerializer;

  ///Throws if [data] is not serializable.
  factory FieldState(FieldID fieldID, T data) => FieldState.fromBuilder((b) => b
    ..fieldID = fieldID
    ..data = data);

  //TODO: make sure to document the fact that an error will be
  //thrown if the Type T is not serializable.
  ///Throws if [data] is not serializable.
  factory FieldState.fromBuilder([updates(FieldStateBuilder<T> b)]) =
      _$FieldState<T>;

  //TODO: add reference to the serializers class where the types that are
  //serializable is listed.

  factory FieldState.fromJSON(String jsonString) {
    //deserialize to FieldState with Object generic
    final FieldState<Object> fieldStateObject = standardJSONSerializers
        .deserializeWith(FieldState.serializer, json.decode(jsonString));
    try {
      //try to cast the FieldState to a FieldState with tighter generic parameter
      //bounds
      final T data = fieldStateObject.data as T;
      return FieldState(fieldStateObject.fieldID, data);
    } catch (e) {
      print(e.runtimeType);
      if (e is CastError) {
        //if the cast to a tighter generic bounds fails throw.
        throw JSONDeserializationCastError(
            fieldStateObject.data.runtimeType, T, jsonString, e);
      } else {
        throw e;
      }
    }
  }

  FieldState._() {
    isSerializable(T);
  }

  //TODO: document the serializer helper methods and add the serializer examplke to the class documentation.

  @nullable
  T get data;

  FieldID get fieldID;

  //this should fix the issue of serializers not being made for all possible
  //generic parameter for a Built  class.
  static String toJSON(FieldState fieldState) =>
      json.encode(standardJSONSerializers.serialize(fieldState));
}

//TODO: document this.-

@immutable
class JSONDeserializationCastError extends Error {
  final Type jsonType;
  final Type fieldStateType;
  final String fieldStateJSON;
  final CastError castError;

  JSONDeserializationCastError(
      this.jsonType, this.fieldStateType, this.fieldStateJSON, this.castError);

  @override
  String toString() =>
      "JSON Generic Type: $jsonType, from jsonString is not a subtype of " +
      "FieldState Generic Type: $fieldStateType.";
}
