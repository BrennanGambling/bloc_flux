import 'base_dispatcher.dart';
import 'package:meta/meta.dart';
import '../action/actions.dart';
import '../blocs/state_bloc.dart';
import '../blocs/bloc.dart';
import '../blocs/value_bloc.dart';
import 'package:rxdart/rxdart.dart';

//TODO: does dispatcher need to handle field/state queries

abstract class Dispatcher implements BaseDispatcher {

  void addInputObservable(String key, Observable<Action> observable);

  void dispatch(Action action);

  void dispose() {
    //TODO: call dispose on all blocs
    //cleanup any resources.
  }

  void removeInputObservable(String key);

}