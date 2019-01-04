import 'package:rxdart/rxdart.dart';
import 'action.dart';

///Extend to create custom Dispatchers.
abstract class BaseDispatcher {
  ///The Stream that ALL blocs receive Actions from.
  final Observable<Action> actionObservable;

  BaseDispatcher(this.actionObservable);

  ///Called to dispatch an Action to the blocs.
  void dispatch(Action action);

  ///Add a new Stream of Actions to pass on to the blocs.
  void addInputStream(Stream<Action> stream);
}
