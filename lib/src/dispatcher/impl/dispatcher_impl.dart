import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../blocs/bloc.dart';
import '../../blocs/state_bloc.dart';
import '../../blocs/value_bloc.dart';
import '../dispatcher.dart';

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

  DispatcherImpl() : this._(PublishSubject(), PublishSubject());

  ///@nodoc
  ///This internal constructor is needed as only static variable and variables
  ///passed in as parameters can be used in the initializer list. To make the
  ///[actionObservable] and [inputObservable] final they must be set here and
  ///[subject] and [_inputSubject] must have been already created to do this.
  DispatcherImpl._(this.subject, this._inputSubject)
      : actionObservable = subject.stream,
        inputObservable = _inputSubject.stream,
        blocMap = Map(),
        valueBlocMap = Map(),
        stateBlocMap = Map(),
        inputObservableMap = Map() {
    _inputObservableDispatchSubscription = inputObservable.listen(dispatch);
  }

  ///{@macro add_bloc}
  void addBloc(Bloc bloc) {
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
  void addInputObservable(String key, Observable<Action> observable) {
    inputObservableMap[key] = observable;
    _createInputObservable();
  }

  ///{@macro dispatch}
  @mustCallSuper
  void dispatch(Action action) {
    subject.add(action);
  }

  ///{@macro dispatcher_dispose}
  void dispose() {
    //TODO: call dispose on all blocs
    //cleanup any resources.
    _inputObservableDispatchSubscription?.cancel();
    _inputObservableSubjectSubscription?.cancel();
    //TODO:dispose blocs

    _inputSubject.close();
    subject.close();
  }

  ///{@macro remove_bloc}
  void removeBloc(Bloc bloc) {
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
  void removeBlocWithKey(String key) {
    blocMap.remove(key);
    valueBlocMap.remove(key);
    stateBlocMap.remove(key);
  }

  ///{@macro remove_input_observable}
  void removeInputObservable(String key) {
    inputObservableMap.remove(key);
    _createInputObservable();
  }

  ///@nodoc
  ///This method cancels the current [_inputObservableSubjectSubscription]
  ///(if not null) creates a new one by adding the [_inputSubject.add] onData
  ///listener to the [Observable] resulting from merging all of the
  ///[Observable]s in [inputObservableMap].
  void _createInputObservable() {
    //TODO: subscription may not be cancelled sync does this matter
    _inputObservableSubjectSubscription?.cancel();
    _inputObservableSubjectSubscription =
        Observable.merge(inputObservableMap.values).listen(_inputSubject.add);
  }
}