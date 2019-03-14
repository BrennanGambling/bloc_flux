import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import '../field/field_id.dart';
import '../query/field_query.dart';
import 'bloc.dart';

///[ValueBloc] interface. Extend this class to create an interface for a [ValueBlocImpl].
///
///See [ValueBlocImpl] for more information.
///{@category Blocs}
abstract class ValueBloc extends Bloc {
  ///{template output_observable}
  ///The [Observable] carrying [Action]s from within this [ValueBlocImpl]
  ///that need to be dispatched.
  ///{@endtemplate}
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
