//Library for the bloc_state file and its generated implementation file.
library bloc_state;

import 'dart:convert' show json;

import 'package:meta/meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import '../serializers.dart';

import 'field_state.dart';

//The file generated by built_value.
part 'bloc_state.g.dart';

//TODO: add the serializer examples and the [] fuctionality examples.
//TODO: add link to the example code file under each H1 header. Usage and Serializer.
//TODO: for the equality checks should the print statements be added or is this pointless as the full code will be linked in.
//TODO: use @template and @macro comment tags to insert the example for there specific constructor pages.

///Contains the state of all of the [StateField]s in the [StateBloc] with the
///key [key].
///
///All fields are immutable.
///
///To get a specific [FieldState] use the list access operator (square brackets)
///with the [FieldState.key] as the "index".
///
///# Usage
///### Setup
///```dart
/////keys for BlocState.
///const String blocKey = "blocKey";
///const String newBlocKey = "newBlocKey";
/////keys for FieldState.
///const String fieldKey1 = "fieldKey1";
///const String fieldKey2 = "fieldKey2";
///
/////create 2 FieldStates
///FieldState<String> field1 = FieldState(fieldKey1, "someData");
///FieldState<int> field2 = FieldState(fieldKey2, 4);
///
/////Create a Map of keys to FieldStates.
///final Map<String, FieldState> map = Map();
///map[field1.key] = field1;
///map[field2.key] = field2;
///
/////Create BuiltMap from Map.
///BuiltMap<String, FieldState> builtMap = BuiltMap.of(map);
///```
///
///### Basic Constructor
///```dart
/////Create a BlocState using the basic constructor.
///BlocState blocState = BlocState(blocKey, builtMap);
///```
///
///### [BlocState] from [BlocStateBuilder]
///```dart
/////Create a BlocState using a BlocStateBuilder.
///BlocState blocStateFromBuilder = BlocState.fromBuilder((b) => b
///  ..key = blocKey
///  ..stateMap = builtMap);
/// ```
///
///### [BlocState] from [String] ([key]) and [BuiltMap<String, FieldState>] ([stateMap])
///```dart
/////Create a BlocState from a Map.
///BlocState blocStateFromMap = BlocState.fromMap(blocKey, map);
///```
///
///### [BlocState] from an existing [BlocState] using [BlocStateBuilder]
///```dart
/////Rebuild a NEW BlocState from an existing BlocState.
/////The original will be unchanged as BlocState is immutable.
///BlocState blocStateRebuild = blocState.rebuild((b) => b..key = newBlocKey);
///```
///
///### Creating and using a [BlocStateBuilder]
///```dart
/////Create a BlocStateBuilder from a BlocState.
/////Any changes made to this Builder will not result in changes in the original
/////BlocState object.
///BlocStateBuilder blocStateBuilder = blocState.toBuilder();
///
/////change the key a few times.
///blocStateBuilder.key = fieldKey1;
/////Doing something else.
///blocStateBuilder.key = newBlocKey;
///
/////build the BlocState.
///BlocState blocStateBuild = blocStateBuilder.build();
///```
///
///### [BlocState] equality
///```dart
/////blocState, blocStateFromMap and blocStateFromBuilder all have fields with
/////the same values and are therefore equal.
///assert(blocState == blocStateFromBuilder);
///assert(blocState == blocStateFromMap);
///
/////blocStateBuild and blocStateRebuild both had there key changed to the
/////newBlocKey and the stateMap is unchanges and they therefore are equal.
///assert(blocStateBuild == blocStateRebuild);
///```
@BuiltValue(nestedBuilders: false)
abstract class BlocState implements Built<BlocState, BlocStateBuilder> {
  ///The key of the [StateBloc] that this [BlocState] represents.
  String get key;

  ///A [BuiltMap] of the [FieldState.key] to [FieldState]s.
  BuiltMap<String, FieldState> get stateMap;

  ///Returns the [FieldState] associated with the [FieldState.key].
  FieldState operator [](String key) => stateMap[key];

  BlocState._();

  factory BlocState(String key, BuiltMap<String, FieldState> stateMap) =>
      BlocState.fromBuilder((b) => b
        ..key = key
        ..stateMap = stateMap);

  factory BlocState.fromMap(String key, Map<String, FieldState> stateMap) =>
      BlocState.fromBuilder((b) => b
        ..key = key
        ..stateMap = BuiltMap(stateMap));

  factory BlocState.fromBuilder([updates(BlocStateBuilder b)]) = _$BlocState;

  static Serializer<BlocState> get serializer => _$blocStateSerializer;

  ///@nodoc
  ///This method currently works but the [deserialize] does not and it therefore
  ///is not usable right now.
  ///
  ///This method will ALWAYS THROW an [UnimplementedError](dart:core).
  @alwaysThrows
  static String serialize(BlocState blocState) => throw UnimplementedError(
      "serialize has not yet been correctly implemented. Use toJSON instead.");
  //json.encode(serializers.serialize(blocState));

  ///Serializes a [BlocState] using the [standardJSONSerializers] and
  ///the [json.encode()](dart:convert) method.
  static String toJSON(BlocState blocState) =>
      json.encode(standardJSONSerializers.serialize(blocState));

  ///@nodoc
  ///Currently does not work due to an issue with what appears to be a missing
  ///"key" for a List which built_value tries to cast to a String.
  ///
  ///This method will ALWAYS THROW an [UnimplementedError](dart:core).
  @alwaysThrows
  factory BlocState.deserialize(String string) => throw UnimplementedError(
      "deserialize has not yet been correctly implemented. Use fromJSON instead.");
  //serializers.deserializeWith(BlocState.serializer, json.decode(string));

  ///Deserializes a [String] using the [standardJSONSerializers] and
  ///the [json.encode()](dart:conver) method.
  factory BlocState.fromJSON(String string) => standardJSONSerializers
      .deserializeWith(BlocState.serializer, json.decode(string));
}
