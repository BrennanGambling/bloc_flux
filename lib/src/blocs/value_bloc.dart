import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import '../field_id.dart';
import '../field_query.dart';
import 'bloc.dart';

abstract class ValueBloc extends Bloc {
  Iterable<FieldID> get fieldIDs;
  Observable<Action> get outputObservable;

  ///{@template invalid_fields}
  ///Returns a BuiltList of FieldIDs in [fieldQuery] not present in this [ValueBloc].
  ///
  ///{@macro closed_state_error}
  ///
  ///An empty list will be returned if all [Field]s are valid.
  ///{@endtemplate}
  Iterable<FieldID> invalidFields(FieldQuery fieldQuery);

  ///{@template is_field_query_valid}
  ///Check if all [Field]s specified are registered in this bloc.
  ///
  ///{@macro closed_state_error}
  ///{@endtemplate}
  bool isFieldQueryValid(FieldQuery fieldQuery);
}
