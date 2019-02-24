import 'package:bloc_flux/bloc_flux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/core.dart';

import 'mock_states.dart';

class MockFieldQuery extends Mock implements FieldQuery {
  @override
  int get hashCode => hash2(this.blocKey, this.fieldIDs);

  @override
  bool operator ==(dynamic other) =>
      (other is FieldQuery) &&
      (this.blocKey == other.blocKey) &&
      (this.fieldIDs == other.fieldIDs);

  static FieldQuery getExampleMock({bool diff = false}) {
    final MockFieldQuery mock = MockFieldQuery();

    final String blocKey = diff ? "diffBlocKey" : "blocKey";
    when(mock.blocKey).thenReturn(blocKey);

    final String fieldKey = diff ? "diffFieldKey" : "fieldKey";
    final FieldID fieldID1 = MockFieldID.getExampleMock(
        fieldNum: 1, blocKey: blocKey, fieldKey: fieldKey);
    final FieldID fieldID2 = MockFieldID.getExampleMock(
        fieldNum: 2, blocKey: blocKey, fieldKey: fieldKey);
    BuiltList<FieldID> fieldList =
        BuiltList.build((b) => b..add(fieldID1)..add(fieldID2));
    when(mock.fieldIDs).thenReturn(fieldList);

    return mock;
  }
}

class MockStateQuery extends Mock implements StateQuery {
  @override
  int get hashCode => blocKey.hashCode;

  @override
  bool operator ==(dynamic other) =>
      (other is StateQuery) && (this.blocKey == other.blocKey);

  static StateQuery getExampleMock({bool diff = false}) {
    final MockStateQuery mock = MockStateQuery();

    final String blocKey = diff ? "diffBlocKey" : "blocKey";

    when(mock.blocKey).thenReturn(blocKey);

    return mock;
  }
}
