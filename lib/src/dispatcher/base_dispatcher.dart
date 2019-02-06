import 'package:rxdart/rxdart.dart';
import '../action/actions.dart';

abstract class BaseDispatcher {
  Observable<Action> get actionObservable;

  void addInputObservable(String key, Observable<Action> observable);

  void dispatch(Action action);

  void dispose();

  void removeInputObservable(String key);
}