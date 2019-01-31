import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../field_id.dart';
import '../../field_query.dart';
import '../../fields/field.dart';
import '../../fields/state_field.dart';
import '../../state_query.dart';
import '../state_bloc.dart';
import 'bloc_impl.dart';
import '../../state/bloc_state.dart';
import 'value_bloc_impl.dart';

abstract class StateBlocImpl extends ValueBlocImpl implements StateBloc {
  @protected
  final Map<FieldID, StateField> stateFieldMap;

  ///This method is called as the last statement in the constructor.
  ///
  ///Override to perform any initialization work.
  @protected
  void init() {}

  int _activeStateQueries;

  ///The number of [StateQueries] currently registered for this [StateBloc].
  ///
  ///Will always be greater than or equal to 0.
  int get activeStateQueries => _activeStateQueries;

  ///The number of [StateQueries] currently registered for this [StateBloc].
  ///
  ///Must be greater than or equal to 0. If this condition is not met
  ///an [ArgumentError] will be thrown.
  set activeStateQueries(int activeStateQueries) {
    if (activeStateQueries >= 0) {
    _activeStateQueries = activeStateQueries;
    _updateDispatchState();
    } else {
      throw ArgumentError("activeStateQueries must be equal to or greater than 0."
      "\nactiveStateQueries: $activeStateQueries");
    }
  }

  bool _forceDispatch;

  ///Whether or not to dispatch [StateBlocValueAction]s if there are no currently
  ///registered [StateQuery]s (activeStateQueries > 0).
  ///
  ///If forceDispatch was set to true in the constructor or permanentForceDispatch
  ///has been called one or more times forceDispatch will always be true. This 
  ///can be checked using the [isForceDispatchPermanent()] method.
  bool get forceDispatch => _forceDispatch || _permanentForceDispatch;

  ///Whether or not to dispatch [StateBlocValueAction]s if there are no currently
  ///registered [StateQuery]s (activeStateQueries > 0).
  ///
  ///If forceDispatch was set to true in the constructor or permanentForceDispatch
  ///has been called one or more times calls to this method will not effect the 
  ///value returned by the [forceDispatch] getter. This can be checked using
  ///the [isForceDispatchPermanent()] method.
  set forceDispatch(bool forceDispatch) => _forceDispatch;

  bool _permanentForceDispatch;
  
  ///Whether or not forceDispatch is permanently set to true. 
  ///
  ///This will be true if forceDispatch was set to true in the constructor or 
  ///[permanentForceDispatch] has been called one or more times.
  bool get isForceDispatchPermanent => _permanentForceDispatch;

  ///Permanently sets the value of [forceDispatch] to true. 
  ///
  ///Any calls to the [forceDispatch] getter will be ignored after this.
  void permanentForceDispatch() {
    _permanentForceDispatch = true;
    _updateDispatchState();
  }

  void _updateDispatchState() {
    final bool newDispatchState = _activeStateQueries > 0 || _forceDispatch;
    if (_dispatchState != newDispatchState) {
      _dispatchState = newDispatchState;
      dispatchStateChanged();
    }
  }



  StreamSubscription _stateQueryActionSubscription;
  void _createQuerySubscription() {}

  StreamSubscription _blocStateActionSubscription;
  void _createStateSubscription() {}

  //TODO: register a listener on the actionObservable (before other listeners that effect state)
  //that calls a method to get the state of this bloc. State should only be sent
  //to stateUpdated if it is not the same as the previous state. This is required
  //as otherwise actions like fieldQueries would be considered statechanges.

  StateBlocImpl(String key, Observable<Action> actionObservable,
      {StateBlocState initialState, bool forceDispatch: false})
      : stateFieldMap = Map(),
        _forceDispatch = forceDispatch,
        _permanentForceDispatch = forceDispatch,
        _activeStateQueries = 0,
        _dispatchState = forceDispatch,
        super(key, actionObservable) {
          _createQuerySubscription();
          _createStateSubscription();
          if (initialState != null) {
            if (isBlocStateValid(initialState)) {
              setState(initialState);
            } else {
              throw InvalidInitialStateError(this, initialState);
            }
          }
          init();
        }

  ///Called when a BlocStateAction with the right key is recieved.
  @protected
  @mustCallSuper
  void setState(StateBlocState blocState) {}

  ///Called when a new [StateBlocState] is avaliable.
  @protected
  @mustCallSuper
  void stateUpdated(StateBlocState stateBlocState) {} 

  ///Called when a StateQueryAction with the right key is recieved.
  @protected
  @mustCallSuper
  void stateQuery(StateQuery stateQuery) {}

  bool _dispatchState;

  ///Whether or not to dispatch new [StateBlocState]s.
  @protected
  bool get dispatchState => _dispatchState;

  ///Called when the value of dispatchState has changed.
  @protected
  @mustCallSuper
  void dispatchStateChanged() {
    //TODO: enable and disable state dispatching.
  }

  @override
  Iterable<FieldID> get stateFieldIDs => stateFieldMap.keys;

  @override
  Iterable<FieldID> invalidStateFields(StateBlocState blocState) {
    final BuiltList<FieldID> fieldIDs = blocState.stateMap.keys;
    final ListBuilder<FieldID> listBuilder = ListBuilder();
    if (blocState.blocKey == key) {
      fieldIDs.forEach((id) {
        if (!stateFieldMap.keys.contains(id)) {
          listBuilder.add(id);
        }
      });
    } else {
      listBuilder.addAll(fieldIDs);
    }
    return listBuilder.build();
  }

  @override
  bool isBlocStateValid(StateBlocState blocState) =>
      blocState.blocKey == key &&
      blocState.stateMap.keys.every((id) => stateFieldMap.keys.contains(id));

  @override
  bool isStateQueryValid(StateQuery stateQuery) => stateQuery.blocKey == key;
}
