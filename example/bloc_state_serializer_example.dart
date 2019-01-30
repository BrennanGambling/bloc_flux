import 'package:bloc_flux/bloc_flux.dart';

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
  final BlocState blocState = BlocState.fromMap(blocKey, map);

  //Serialized blocState String.
  final String blocStateToJSON = BlocState.toJSON(blocState);

  //BlocState deserialized from blocStateToJSON.
  final BlocState blocStateFromJSON = BlocState.fromJSON(blocStateToJSON);

  print('''blocState:
  $blocState\n
  BlocState.toJSON(blocState):
  $blocStateToJSON\n
  BlocState.fromJSON(blocStateToJSON):
  $blocStateFromJSON\n''');

  //verify that the original and deserialized blocStates are equal.
  final bool fromJSONCheck = blocState == blocStateFromJSON;
  print("blocState == blocStateFromJSON:\n$fromJSONCheck");
}
