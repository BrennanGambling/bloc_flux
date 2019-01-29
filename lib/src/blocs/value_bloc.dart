import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import '../field_id.dart';
import '../field_query.dart';
import 'bloc.dart';

abstract class ValueBloc extends Bloc {
  Iterable<FieldID> get fieldIDs;
  Observable<Action> get outputObservable;
  void fieldQuery(FieldQuery fieldQuery);
  bool fieldQueryIsValid(FieldQuery fieldQuery);
  BuiltList<FieldID> invalidFields(FieldQuery fieldQuery);
}
