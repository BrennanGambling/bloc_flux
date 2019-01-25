import 'package:bloc_flux/bloc_flux.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  //keys for BlocState.
  const String blocKey = "blocKey";
  const String newBlocKey = "newBlocKey";
  //keys for FieldState.
  const String fieldKey1 = "fieldKey1";
  const String fieldKey2 = "fieldKey2";

  //create 2 FieldStates
  FieldState<String> field1 = FieldState(fieldKey1, "someData");
  FieldState<int> field2 = FieldState(fieldKey2, 4);

  //Create a Map of keys to FieldStates.
  final Map<String, FieldState> map = Map();
  map[field1.key] = field1;
  map[field2.key] = field2;

  //Create BuiltMap from Map.
  BuiltMap<String, FieldState> builtMap = BuiltMap.of(map);

  //Create a BlocState using the basic constructor.
  BlocState blocState = BlocState(blocKey, builtMap);

  //Create a BlocState using a BlocStateBuilder.
  BlocState blocStateFromBuilder = BlocState.fromBuilder((b) => b
    ..key = blocKey
    ..stateMap = builtMap);

  //Create a BlocState from a Map.
  BlocState blocStateFromMap = BlocState.fromMap(blocKey, map);

  //Rebuild a NEW BlocState from an existing BlocState.
  //The original will be unchanged as BlocState is immutable.
  BlocState blocStateRebuild = blocState.rebuild((b) => b..key = newBlocKey);

  //Create a BlocStateBuilder from a BlocState.
  //Any changes made to this Builder will not result in changes in the original
  //BlocState object.
  BlocStateBuilder blocStateBuilder = blocState.toBuilder();

  //change the key a few times.
  blocStateBuilder.key = fieldKey1;
  //Doing something else.
  blocStateBuilder.key = newBlocKey;

  //build the BlocState.
  BlocState blocStateBuild = blocStateBuilder.build();

  //blocState, blocStateFromMap and blocStateFromBuilder all have fields with
  //the same values and are therefore equal.
  final bool builderCheck = blocState == blocStateFromBuilder;
  assert(builderCheck);
  print("blocState == blocStateFromBuilder:\n$builderCheck");

  final bool mapCheck = blocState == blocStateFromMap;
  assert(mapCheck);
  print("blocState == blocStateFromMap:\n$mapCheck");

  //blocStateBuild and blocStateRebuild both had there key changed to the
  //newBlocKey and the stateMap is unchanges and they therefore are equal.
  final bool buildRebuildCheck = blocStateBuild == blocStateRebuild;
  assert(buildRebuildCheck);
  print("blocStateBuild == blocStateRebuild:\n$buildRebuildCheck");
}
