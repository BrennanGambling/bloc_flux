import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import '../field_id.dart';
import '../field_query.dart';
import 'bloc.dart';

abstract class ValueBloc extends Bloc {
  Iterable<FieldID> get fieldIDs;
  Observable<Action> get outputObservable;
  Iterable<FieldID> invalidFields(FieldQuery fieldQuery);
  bool isFieldQueryValid(FieldQuery fieldQuery);
}
