import 'package:built_collection/built_collection.dart';
import 'package:bloc_flux/bloc_flux.dart';
import 'dart:convert';

void main() {
  //keys for BlocState.
  const String blocKey = "blocKey";
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

  //Create a BlocState using the basic constructor.
  final StateBlocState blocState = StateBlocState(stateMap: BuiltMap(map));

  final String serialized = StateBlocState.serialize(blocState);
  final StateBlocState deserialized = StateBlocState.deserialize(serialized);

  assert(blocState == deserialized);
}