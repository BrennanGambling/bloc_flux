import 'package:bloc_flux/bloc_flux.dart';

void main() {
  const String fieldStateKey = "fieldStateKey";
  
  //Create a FieldState using the basic constructor.
  final FieldState<int> fieldState = FieldState(fieldStateKey, 6);

  //Serialized FieldState String.
  final String fieldStateSerialized = FieldState.toJSON(fieldState);

  //FieldState deserialized from fieldStateSerialized.
  final FieldState<int> fieldStateDeserialized =
      FieldState.fromJSON(fieldStateSerialized);

  print('''fieldState:
  $fieldState\n
  FieldState.toJSON(fieldState):
  $fieldStateSerialized\n
  FieldState.fromJSON(fieldStateSerialized):
  $fieldStateDeserialized\n''');

  //Verify the original FieldState and deserialized FieldState are equal.
  final bool fromJSONCheck = fieldState == fieldStateDeserialized;
  print("fieldState == fieldStateDeserialized:\n$fromJSONCheck");
}
