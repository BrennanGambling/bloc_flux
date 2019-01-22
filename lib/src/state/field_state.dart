library field_state;

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'field_state.g.dart';

///Contains the last output of a [StateField] with the key [key] in field [data].
abstract class FieldState<T>
    implements Built<FieldState<T>, FieldStateBuilder<T>> {
  String get key;

  T get data;

  //TODO: make sure to document the fact that an error will be
  //thrown if the Type T is not serializable.
  FieldState._() {
    isSerializable(T);
  }

  //TODO: add reference to the serializers class where the types that are
  //serializable is listed.

  ///Throws if [data] is not serializable.
  factory FieldState(String key, T data) => FieldState.fromBuilder((b) => b
    ..key = key
    ..data = data);

  ///Throws if [data] is not serializable.
  factory FieldState.fromBuilder([updates(FieldStateBuilder<T> b)]) =
      _$FieldState<T>;

  //TODO: document the serializer helper methods and add the serializer examplke to the class documentation.

  static Serializer<FieldState> get serializer => _$fieldStateSerializer;

  static String toJSON(FieldState fieldState) =>
      json.encode(standardJSONSerializers.serialize(fieldState));

  //this should fix the issue of serializers not being made for all possible
  //generic parameter for a Built  class.
  factory FieldState.fromJSON(String jsonString) {
    //deserialize to FieldState with Object generic
    final FieldState<Object> fieldStateObject = standardJSONSerializers
        .deserializeWith(FieldState.serializer, json.decode(jsonString));
    try {
      //try to cast the FieldState to a FieldState with tighter generic parameter
      //bounds
      final T data = fieldStateObject.data as T;
      return FieldState(fieldStateObject.key, data);
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
