import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import '../field_id.dart';
import '../query/field_query.dart';
import 'bloc.dart';

abstract class ValueBloc extends Bloc {
  Iterable<FieldID> get fieldIDs;
  Observable<Action> get outputObservable;

  ///{@template invalid_fields}
  ///Returns an [Iterable] of [FieldID]s in [fieldQuery] that do not have [Field]s
  ///in this [ValueBloc] with equal [FieldID]s.
  ///
  ///All [FieldID]s will be returned if [FieldQuery.blocKey] does not equal [key].
  ///
  ///An empty list will be returned if all [Field]s are valid.
  ///{@endtemplate}
  ///
  ///{@macro closed_state_error}
  Iterable<FieldID> invalidFields(FieldQuery fieldQuery);

  ///{@template is_field_query_valid}
  ///Check if all [Field]s specified are registered in this [ValueBloc].
  ///{@endtemplate}
  ///
  ///{@macro closed_state_error}
  bool isFieldQueryValid(FieldQuery fieldQuery);
}
