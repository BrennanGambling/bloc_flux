import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../bloc/bloc.dart';
import '../../bloc/state_bloc.dart';
import '../../bloc/value_bloc.dart';
import '../dispatcher.dart';

///[Dispatcher] implementation.
///
///Extend this class to create a [Dispatcher] with basic functionality and
///management of the [ValueBloc.outputObservable] for [ValueBloc] and its
///subclasses.
///
///{@macro impl_needs_interface}
class DispatcherImpl implements Dispatcher {
  ///The [Subject] managing the [actionObservable].
  @protected
  final Subject<Action> subject;

  ///@nodoc
  ///The [Subject] managing the [inputObservable].
  ///
  ///This was done because the [inputObservable] was previously being changed
  ///every time a input observable was added or removed. This means the
  ///subscriptions on the previous observable would have to be canceled and
  ///a new subscription would have to be created in the new one.
  final Subject<Action> _inputSubject;

  ///{@macro action_observable}
  final Observable<Action> actionObservable;

  ///The [Observable] carrying the [Action]s being dispatched through all
  ///added [Observable]s.
  @protected
  final Observable<Action> inputObservable;

  ///{@template bloc_map}
  ///A map of all registered [Bloc]s with the [Bloc]s key as the maps key
  ///and the [Bloc] as the value.
  ///
  ///This includes the [Bloc]s in [valueBlocMap] and [stateBlocMap].
  ///{@endtemplate}
  @protected
  final Map<String, Bloc> blocMap;

  ///{@template value_bloc_map}
  ///A map of all registered [ValueBloc]s with the [ValueBloc]s key as the maps
  ///key and the [ValueBloc] as the value.
  ///
  ///This includes the [Bloc]s in [stateBlocMap].
  ///{@endtemplate}
  @protected
  final Map<String, ValueBloc> valueBlocMap;

  ///{@template state_bloc_map}
  ///A map of all registered [StateBloc]s with the [StateBloc]s key as the maps
  ///key and the [StateBloc] as the value.
  ///{@endtemplate}
  @protected
  final Map<String, StateBloc> stateBlocMap;

  ///{@template input_observable_map}
  ///A map of all added input [Observable]s with the String given when it was
  ///added as the key and the [Observable] as the value.
  ///{@endtemplate}
  @protected
  final Map<String, Observable<Action>> inputObservableMap;

  ///@nodoc
  ///[StreamSubscription] for the [dispatch] onData listener for
  ///the [inputObservable].
  ///
  ///This [StreamSubscription] is created in the constructor body and will be
  ///canceled in the [dispose] method.
  StreamSubscription _inputObservableDispatchSubscription;

  ///@nodoc
  ///[StreamSubscription] for [_inputSubject.add] onData listener for the
  ///[Observable] resulting from merging all of the [Observable]s in
  ///[inputObservableMap].
  ///
  ///This [StreamSubscription] is canceled (if not null) and recreated in every
  ///call to [_createInputObservable]. It is also canceled (if not null) in the
  ///[dispose] method.
  StreamSubscription _inputObservableSubjectSubscription;

  ///@nodoc
  ///{@macro _closed}
  bool _closed;

  DispatcherImpl() : this._(PublishSubject(), PublishSubject());

  ///@nodoc
  ///This internal constructor is needed as only static variable and variables
  ///passed in as parameters can be used in the initializer list. To make the
  ///[actionObservable] and [inputObservable] final they must be set here and
  ///[subject] and [_inputSubject] must have been already created to do this.
  DispatcherImpl._(this.subject, this._inputSubject)
      : actionObservable = subject.stream,
        inputObservable = _inputSubject.stream,
        _closed = false,
        blocMap = Map(),
        valueBlocMap = Map(),
        stateBlocMap = Map(),
        inputObservableMap = Map() {
    _inputObservableDispatchSubscription = inputObservable.listen(dispatch);
  }

  ///{@macro dispatcher_closed_getter}
  bool get closed => _closed;

  ///{@macro add_bloc}
  ///
  ///{@macro dispatcher_closed}
  void addBloc(Bloc bloc) {
    checkClosed();
    final String key = bloc.key;
    blocMap[key] = bloc;
    if (bloc is ValueBloc) {
      valueBlocMap[key] = bloc;
    }
    if (bloc is StateBloc) {
      stateBlocMap[key] = bloc;
    }
  }

  ///{@macro add_input_observable}
  ///
  ///{@macro dispatcher_closed}
  void addInputObservable(String key, Observable<Action> observable) {
    checkClosed();
    inputObservableMap[key] = observable;
    _createInputObservable();
  }

  ///@nodoc
  ///Checks if this [Dispatcher] has been closed and if it has throws a [StateError].
  void checkClosed() {
    if (closed) {
      throw StateError(
          "This Dispatcher has already had dispose() called on it.");
    }
  }

  ///{@macro dispatch}
  ///
  ///{@macro dispatcher_closed}
  @mustCallSuper
  void dispatch(Action action) {
    checkClosed();
    subject.add(action);
  }

  ///{@macro dispatcher_dispose}
  ///
  ///{@template dispatcher_closed}
  ///This method will throw a StateError if this is closed. A [Dispatcher] is
  ///closed after its [dispose] method is called. To see if a [Dispatcher] is
  ///closed use getter [closed].
  ///{@endtemplate}
  void dispose() {
    checkClosed();
    _inputObservableDispatchSubscription?.cancel();
    _inputObservableSubjectSubscription?.cancel();

    blocMap.values.forEach((bloc) => bloc.dispose());

    _inputSubject.close();
    subject.close();
    _closed = true;
  }

  ///{@macro remove_bloc}
  ///
  ///{@macro dispatcher_closed}
  void removeBloc(Bloc bloc) {
    checkClosed();
    final String key = bloc.key;
    blocMap.remove(key);
    if (bloc is ValueBloc) {
      valueBlocMap.remove(key);
    }
    if (bloc is StateBloc) {
      stateBlocMap.remove(key);
    }
  }

  ///{@macro remove_bloc_with_key}
  ///
  ///{@macro dispatcher_closed}
  void removeBlocWithKey(String key) {
    checkClosed();
    blocMap.remove(key);
    valueBlocMap.remove(key);
    stateBlocMap.remove(key);
  }

  ///{@macro remove_input_observable}
  ///
  ///{@macro dispatcher_closed}
  void removeInputObservable(String key) {
    checkClosed();
    inputObservableMap.remove(key);
    _createInputObservable();
  }

  ///@nodoc
  ///This method cancels the current [_inputObservableSubjectSubscription]
  ///(if not null) creates a new one by adding the [_inputSubject.add] onData
  ///listener to the [Observable] resulting from merging all of the
  ///[Observable]s in [inputObservableMap].
  ///
  ///{@macro dispatcher_closed}
  void _createInputObservable() {
    checkClosed();
    //TODO: subscription may not be cancelled sync does this matter
    _inputObservableSubjectSubscription?.cancel();
    _inputObservableSubjectSubscription =
        Observable.merge(inputObservableMap.values).listen(_inputSubject.add);
  }
}
