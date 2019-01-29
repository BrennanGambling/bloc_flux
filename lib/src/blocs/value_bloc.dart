import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import '../field_query.dart';
import 'bloc.dart';

abstract class ValueBloc extends Bloc {
  Observable<Action> get outputObservable;
  void fieldQuery(FieldQuery fieldQuery);
}
