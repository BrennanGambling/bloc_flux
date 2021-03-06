import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';

///The interface of the most basic dispatcher.
abstract class BaseDispatcher {
  ///{@template action_observable}
  ///The Observable that carries the dispatched [Action]s.
  ///{@endtemplate}
  Observable<Action> get actionObservable;

  ///{@template dispatcher_closed_getter}
  ///Check if this [BaseDispatcher] is closed.
  ///
  ///A [BaseDispatcher] is closed after it's [dispose] method has been called.
  ///{@endtemplate}
  bool get closed;

  ///{@template add_input_observable}
  ///Start dispatching all [Action]s from [observable].
  ///
  ///If an Observable was already added with [key] it will be replaced
  ///with [observable].
  ///
  ///[key] can be passed to [removeInputObservable] to stop dispatching the
  ///[Action]s from [observable].
  ///{@endtemplate}
  ///
  ///{@macro dispatcher_closed}
  void addInputObservable(String key, Observable<Action> observable);

  ///{@template dispatch}
  ///Dispatch [action] to all observers of [actionObservable].
  ///{@endtemplate}
  ///
  ///{@macro dispatcher_closed}
  void dispatch(Action action);

  ///{@template dispatcher_dispose}
  ///Perfrom any cleanup operations required.
  ///
  ///**ALL REGISTERED BLOCS WILL ALSO HAVE THEIR DISPOSE METHOD CALLED.**
  ///
  ///This dispatcher should **NOT** be used again.
  ///{@endtemplate}
  ///
  ///{@macro dispatcher_closed}
  void dispose();

  ///{@template remove_input_observable}
  ///Stop dispatching [Action]s from the [Observable] added with [key].
  ///
  ///If no [Observable]s have been added with [key] nothing will happen.
  ///{@endtemplate}
  ///
  ///{@macro dispatcher_closed}
  void removeInputObservable(String key);
}
