import 'package:bloc_flux/bloc_flux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/core.dart';

//TODO: built_value is trying to build these classes and there is no way to tell it
//to ignore them. Interfaces for each of the builf_value classes may need to be created.

class MockFieldID extends Mock implements FieldID {
  @override
  int get hashCode => hash2(this.blocKey, this.fieldKey);

  @override
  bool operator ==(dynamic other) =>
      (other is FieldID) &&
      (this.blocKey == other.blocKey) &&
      (this.fieldKey == other.fieldKey);

  static FieldID getExampleMock(
      {int fieldNum,
      String blocKey = "blocKey",
      String fieldKey = "fieldKey"}) {
    final MockFieldID mock = MockFieldID();

    when(mock.blocKey).thenReturn("blocKey");

    final String actualFieldKey =
        fieldNum == null ? fieldKey : (fieldKey + fieldNum.toString());
    when(mock.fieldKey).thenReturn(actualFieldKey);

    return mock;
  }
}

class MockStateBlocState extends Mock implements StateBlocState {
  @override
  int get hashCode => hash2(this.blocKey, this.stateMap);

  @override
  bool operator ==(dynamic other) =>
      (other is StateBlocState) &&
      (this.blocKey == other.blocKey) &&
      (this.stateMap == other.stateMap);

  static StateBlocState getExampleMock({bool diff = false}) {
    final MockStateBlocState mock = MockStateBlocState();

    final String fieldKey = diff ? "diffFieldKey" : "fieldKey";

    final MockStateFieldState<String> fieldState1 =
        MockStateFieldState.getExampleMock(fieldNum: 1, fieldKey: fieldKey);
    final MockStateFieldState<String> fieldState2 =
        MockStateFieldState.getExampleMock(fieldNum: 2, fieldKey: fieldKey);

    final BuiltMap<FieldID, StateFieldState> map = BuiltMap.build((b) {
      b[fieldState1.fieldID] = fieldState1;
      b[fieldState2.fieldID] = fieldState2;
    });

    when(mock.blocKey).thenReturn(fieldState1.fieldID.blocKey);
    when(mock.stateMap).thenReturn(map);

    return mock;
  }
}

@BuiltValue(instantiable: false)
class MockStateFieldState<T> extends Mock implements StateFieldState<T> {
  @override
  int get hashCode => hash2(this.fieldID, this.data);

  @override
  bool operator ==(dynamic other) =>
      (other is StateFieldState) &&
      (this.fieldID == other.fieldID) &&
      (this.data == other.data);

  static StateFieldState<String> getExampleMock(
      {int fieldNum,
      String blocKey = "blocKey",
      String fieldKey = "fieldKey",
      String data = "exampleData"}) {
    final MockStateFieldState<String> mock = MockStateFieldState();
    final MockFieldID mockFieldID = MockFieldID.getExampleMock(
        fieldNum: fieldNum, blocKey: blocKey, fieldKey: fieldKey);

    when(mock.fieldID).thenReturn(mockFieldID);
    when(mock.data).thenReturn(data);

    return mock;
  }
}
