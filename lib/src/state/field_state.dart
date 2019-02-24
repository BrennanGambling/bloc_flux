library field_state;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../field/field_id.dart';
import '../serializers/serializers.dart';

part 'field_state.g.dart';

/*TODO: make sure the changing of data field to nullable does not have
any unintended side effects. This was done because the state of some 
state fields will be mull if an initial state is not given.*/

//TODO: add link to a serialization page were all of the types that can be serialized
//by default is listed.

///Wraps the last output of the [StateField] with [StateField.fieldID] equal
///to [fieldID].
///
///{@macro field_state_fieldID}
///
///{@macro field_state_data}
///
///{@template generic_must_be_serializable}
///*** Serialization
///[T] must be a serializable type. Use [isSerializable()] to check if a Type
///is serializable. If [isSerializable()] returns false for a Type that has
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
///If generic parameters are not declared an **error may be thrown** on serialization/
///deserialization if a given generic type is not serializable.
///
///See [isSerializable()] for more information.
///{@endtemplate}
@BuiltValue(nestedBuilders: false)
abstract class StateFieldState<T>
    implements Built<StateFieldState<T>, FieldStateBuilder<T>> {
  ///The [Serializer] for this class.
  static Serializer<StateFieldState> get serializer => _$fieldStateSerializer;

  ///Instaniates a [StateFieldState].
  ///
  ///{@macro field_state_fieldID}
  ///
  ///{@macro field_state_data}
  ///
  ///{@macro generic_must_be_serializable}
  factory StateFieldState(FieldID fieldID, T data) =>
      StateFieldState.fromBuilder((b) => b
        ..fieldID = fieldID
        ..data = data);

  ///Deserialize a serialized [StateFieldState] using the default serialization format.
  ///
  ///[serialized] will first be decoded using [jsonDecode()] and then
  ///deserialized using [blocFluxSerialization].
  ///
  ///{@maceo specifiedType_param}
  ///
  ///{@macro generic_full_type}
  ///
  ///{@macro generic_must_be_serializable}
  ///
  ///{@macro serializers_diff}
  factory StateFieldState.deserialize(String serialized,
          {FullType specifiedType}) =>
      StateFieldState._deserialize(
          serialized, specifiedType, blocFluxSerializers);

  ///Instantiates a [StateFieldState] using a [FieldStateBuilder] that can be updated
  ///using the provided function which takes a [FieldStateBuilder] as a parameter.
  ///
  ///{@macro field_state_fieldID}
  ///
  ///{@macro field_state_data}
  ///
  ///{@macro generic_must_be_serializable}
  factory StateFieldState.fromBuilder([updates(FieldStateBuilder<T> b)]) =
      _$FieldState<T>;

  ///Deserialize a serialized [StateFieldState] using the standard json format.
  ///
  ///[jsonString] will first be decoded using [jsonDecode()] and then
  ///deserialized using the [standardJsonSerializers].
  ///
  ///{@template specifiedType_param}
  ///The same [specifiedType] must be used for serialization and deserialization
  ///of an instance of [StateFieldState].
  ///{@endtemplate}
  ///
  ///{@template generic_full_type}
  ///If [T] is a [Type] with generic parameters, [specifiedType] should be specified,
  ///otherwise serialization or deserialization may fail. [specifiedType] should
  ///be the [FullType] equivalent to [T].
  ///{@endtemplate}
  ///
  ///{@macro generic_must_be_serializable}
  ///
  ///{@macro serializers_diff}
  factory StateFieldState.fromJson(String jsonString,
          {FullType specifiedType}) =>
      StateFieldState._deserialize(
          jsonString, specifiedType, standardJsonSerializers);

  ///@nodoc
  ///Internal constructor checks if generic parameter [Type] [T] is serializable
  ///by calling [isSerializable()].
  StateFieldState._() {
    isSerializable(type: T, shouldThrow: true, objectIsSerializable: true);
  }

  ///@nodoc
  ///Internal method for deserialization.
  ///
  ///[fromJson()] and [deserialize()] forward [serialized] and [specifiedType] and
  ///then provide the appropriate [Serializers] instance.
  factory StateFieldState._deserialize(
      String serialized, FullType specifiedType, Serializers serializers) {
    FullType fullType = specifiedType;
    if (specifiedType == null || specifiedType.isUnspecified) {
      fullType = FullType(T);
    } else if (fullType.root != T) {
      throw ArgumentError(
          "The FullType.root of specifiedType must be equal to T.");
    }
    addBuilderFactory(fullType, () => FieldStateBuilder<T>());
    return serializers.deserialize(jsonDecode(serialized),
        specifiedType: fullType);
  }

  ///The output from [StateField] this [StateFieldState] represents.
  ///
  ///{@template field_state_data}
  ///[data] can be null.
  ///{@endtemplate}
  @nullable
  T get data;

  ///The [StateField] with [Field.fieldID] that this [StateFieldState] represents.
  ///
  ///{@template field_state_fieldID}
  ///[fieldID] **MUST NOT** be null.
  ///{@endtemplate}
  FieldID get fieldID;

  ///Serializes this [StateFieldState] using the default serialization format
  ///
  ///this [StateFieldState] is first serialized using the [standardJsonSerializers]
  ///and then encoded to a String using [jsonEncode()].
  ///
  ///{@macro specifiedType_param}
  ///
  ///{@macro generic_full_type}
  ///
  ///{@macro generic_must_be_serializable}
  ///
  ///{@macro serializers_diff}
  String serialize({FullType specifiedType}) =>
      _serialize(specifiedType, blocFluxSerializers);

  ///Serializes this [StateFieldState] using the standard json format.
  ///
  ///this [StateFieldState] is first serialized using the [standardJsonSerializers]
  ///and then encoded to a String using [jsonEncode()].
  ///
  ///{@macro specifiedType_param}
  ///
  ///{@macro generic_full_type}
  ///
  ///{@macro generic_must_be_serializable}
  ///
  ///{@macro serializers_diff}
  String toJson({FullType specifiedType}) =>
      _serialize(specifiedType, standardJsonSerializers);

  ///@nodoc
  ///Internal method for serialization.
  ///
  ///[toJson()] and [serialize()] forward [specifiedType] and provides the
  ///appropriate [Serializers] instance.
  String _serialize(FullType specifiedType, Serializers serializers) {
    FullType fullType = specifiedType;
    //TODO: make sure this wont call isUnspecified on a null. The conditianl should stop calculating if the first is true.
    if (specifiedType == null || specifiedType.isUnspecified) {
      fullType = FullType(T);
    } else if (fullType.root != T) {
      throw ArgumentError(
          "The FullType.root of specifiedType must be equal to T.");
    }

    return jsonEncode(serializers.serialize(this,
        specifiedType: FullType(StateFieldState, [fullType])));
  }
}
