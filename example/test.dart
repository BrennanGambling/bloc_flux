import 'package:built_collection/built_collection.dart';
import 'package:bloc_flux/bloc_flux.dart';
import 'dart:convert';
import 'package:built_value/serializer.dart';

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
/*
  String serializedField = field1.serialize();
  FieldState<String> deserializedField = FieldState.deserialize(serializedField);*/

  final FullType fullType = FullType(FieldState, [FullType(String)]);

  addBuilderFactory(fullType, () => FieldStateBuilder<String>());

  final String serializedField = json.encode(blocFluxSerializers.serialize(field1));
  final FieldState deserializedField = blocFluxSerializers.deserialize(json.decode(serializedField));

  print("${field1 == deserializedField}");

  blocFluxSerializers.expectBuilder(FullType(FieldState, [FullType(String)]));

  //Create a Map of keys to FieldStates.
  /*final Map<FieldID, FieldState> map = Map();
  map[field1.fieldID] = field1;
  map[field2.fieldID] = field2;

  //Create a BlocState using the basic constructor.
  final StateBlocState blocState = StateBlocState(stateMap: BuiltMap(map));

  final String serialized = blocState.serialize();
  final StateBlocState deserialized = StateBlocState.deserialize(serialized);

  assert(blocState == deserialized);*/


}