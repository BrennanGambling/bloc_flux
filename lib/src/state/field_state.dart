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

//TODO: add link to a serialization page were all of the types that can be serialized
//by default is listed.

///Wraps the last output of the [StateField] with [StateField.fieldID] equal
///to [fieldID].
///
///[data] can be null.
///
///[fieldID] **MUST NOT** be null.
///
///{@template generic_must_be_serializable}
///[T] must be a serializable type. Use [isSerializable()] to check if a [Type]
///is serializable. If [isSerializable()] returns false for a [Type] that has
///an available [Serializer] make sure the [Serializer] has been added using
///this [addSerializer()] method. A [Serializers] instance can also be added using
///the [addSerializers()] method to add all [Serializers] is a project.
///
///If [T] has generic parameters perfer to declare them when declaring [T]:
///```dart
///FieldState<ObjectWithGenerics<ASerializableType>>
///```
///instead of:
///```dart
///FieldState<ObjectWithGenerics>
///```
///
///If generic parameters are not declared an error may be thrown on serialization/
///deserialization if a given generic type is not serializable.
///{@endtemplate}
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
    final FieldState<Object> fieldStateObject = standardJsonSerializers
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
    isSerializable(T, shouldThrow: true, objectIsSerializable: true);
  }

  //TODO: document the serializer helper methods and add the serializer examplke to the class documentation.

  @nullable
  T get data;

  FieldID get fieldID;

  //this should fix the issue of serializers not being made for all possible
  //generic parameter for a Built  class.
  static String toJSON(FieldState fieldState) =>
      json.encode(standardJsonSerializers.serialize(fieldState));
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
