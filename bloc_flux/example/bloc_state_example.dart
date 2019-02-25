/*import 'package:bloc_flux/bloc_flux.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  //keys for BlocState.
  const String blocKey = "blocKey";
  const String newBlocKey = "newBlocKey";
  //keys for FieldState.
  const String fieldKey1 = "fieldKey1";
  final FieldID fieldID1 = FieldID(blocKey, fieldKey1);
  const String fieldKey2 = "fieldKey2";
  final FieldID fieldID2 = FieldID(blocKey, fieldKey2);

  //create 2 FieldStates
  FieldState<String> field1 = FieldState(fieldID1, "someData");
  FieldState<int> field2 = FieldState(fieldID2, 4);

  //Create a Map of keys to FieldStates.
  final Map<FieldID, FieldState> map = Map();
  map[field1.fieldID] = field1;
  map[field2.fieldID] = field2;

  //Create BuiltMap from Map.
  BuiltMap<FieldID, FieldState> builtMap = BuiltMap.of(map);

  //Create a BlocState using the basic constructor.
  StateBlocState blocState = StateBlocState(blocKey, builtMap);

  //Create a BlocState using a BlocStateBuilder.
  StateBlocState blocStateFromBuilder = StateBlocState.fromBuilder((b) => b
    ..blocKey = blocKey
    ..stateMap = builtMap);

  //Create a BlocState from a Map.
  StateBlocState blocStateFromMap = StateBlocState.fromMap(blocKey, map);

  //Rebuild a NEW BlocState from an existing BlocState.
  //The original will be unchanged as BlocState is immutable.
  StateBlocState blocStateRebuild =
      blocState.rebuild((b) => b..blocKey = newBlocKey);

  //Create a BlocStateBuilder from a BlocState.
  //Any changes made to this Builder will not result in changes in the original
  //BlocState object.
  StateBlocStateBuilder blocStateBuilder = blocState.toBuilder();

  //change the key a few times.
  blocStateBuilder.blocKey = fieldKey1;
  //Doing something else.
  blocStateBuilder.blocKey = newBlocKey;

  //build the BlocState.
  StateBlocState blocStateBuild = blocStateBuilder.build();

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
*/