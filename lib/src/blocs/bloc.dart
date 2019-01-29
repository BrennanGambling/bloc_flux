import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';

//TODO: when source generation is added generate interfaces for blocs with just
//the added fields and key visible. maybe for annotated members only

///Basic Bloc interface.
///
///Extend this class to create the interface for a Bloc.
abstract class Bloc {
  ///A unique identifer for this bloc.
  String get key;
  
  ///The observable with [Action]s from the dispatcher.
  @protected
  Observable<Action> get actionObservable;

  ///Dispose of all resources.
  void dispose();
}