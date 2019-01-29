import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import 'bloc.dart';

abstract class ValueBloc extends Bloc {
  Observable<Action> get outputObservable;
}