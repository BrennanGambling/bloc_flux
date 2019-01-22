import 'package:bloc_flux/bloc_flux.dart';
import 'dart:convert';

void main() {
  //keys for BlocState.
  const String blocKey = "blocKey";
  //keys for FieldState.
  const String fieldKey1 = "fieldKey1";
  const String fieldKey2 = "fieldKey2";

  //create 2 FieldStates
  final FieldState<String> field1 = FieldState((b) => b
    ..key = fieldKey1
    ..data = "somedata");
  final FieldState<int> field2 = FieldState((b) => b
    ..key = fieldKey2
    ..data = 4);

  //Create a Map of keys to FieldStates.
  final Map<String, FieldState> map = Map();
  map[field1.key] = field1;
  map[field2.key] = field2;

  //Create a BlocState using the basic constructor.
  final BlocState blocState = BlocState.fromMap(blocKey, map);

  //Serialized blocState String.
  final String blocStateToJSON = BlocState.toJSON(blocState);

  //BlocState deserialized from blocState.
  final BlocState blocStateFromJSON = BlocState.fromJSON(blocStateToJSON);

  print('''blocState:\n
  $blocState\n\n
  BlocState.toJSON(blocState):\n
  $blocStateToJSON\n\n
  BlocState.fromJSON(blocState:\n
  $blocStateFromJSON\n\n''');

  //verify that the original and deserialized blocStates are equal.
  final bool fromJSONCheck = blocState == blocStateFromJSON;
  print("blocState == blocStateFromJSON:\n$fromJSONCheck");
}
