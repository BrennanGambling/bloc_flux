import 'package:meta/meta.dart';
import '../../action/actions.dart';
import '../../blocs/state_bloc.dart';
import '../../blocs/bloc.dart';
import '../../blocs/value_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../dispatcher.dart';

class DispatcherImpl implements Dispatcher {
  @protected
  final PublishSubject<Action> subject;

  final Observable<Action> actionObservable;

  Observable<Action> _inputObservable;

  Observable<Action> get inputObservable => _inputObservable;

  @protected
  final Map<String, Bloc> blocMap;

  @protected
  final Map<String, ValueBloc> valueBlocMap;

  @protected
  final Map<String, StateBloc> stateBlocMap;

  @protected
  final Map<String, Observable> inputObservableMap;

  DispatcherImpl() : this._(PublishSubject());

  DispatcherImpl._(this.subject) :
  actionObservable = subject.stream,
  _inputObservable = Observable.never(),
  blocMap = Map(),
  valueBlocMap = Map(),
  stateBlocMap = Map(),
  inputObservableMap = Map();

  void addInputObservable(String key, Observable<Action> observable) {
  
  }

  void dispatch(Action action) {}

  void dispose() {
    //TODO: call dispose on all blocs
    //cleanup any resources.
  }

  void removeInputObservable(String key) {}
}
