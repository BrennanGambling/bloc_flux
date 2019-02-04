import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../action/bloc_actions.dart';
import '../../field_id.dart';
import '../../fields/state_field.dart';
import '../../state/bloc_state.dart';
import '../../state_query.dart';
import '../state_bloc.dart';
import 'value_bloc_impl.dart';

abstract class StateBlocImpl extends ValueBlocImpl implements StateBloc {
  ///The map of all [StateField] [FieldID]s to registered [StateField]s.
  @protected
  final Map<FieldID, StateField> stateFieldMap;

  ///@nodoc
  ///Internal variable for [activeStateQueries] getter and setter.
  int _activeStateQueries;

  ///@nodoc
  ///Internal variable for [forceDispatch] getter and setter.
  bool _forceDispatch;

  ///@nodoc
  ///Internal variable for method [permanentForceDispatch()] and getter [isPermanentForceDispatch].
  bool _permanentForceDispatch;

  ///All incoming [StateQuery]s with this [StateBloc]'s key.
  @protected
  final Observable<StateQuery> stateQueryObservable;

  ///All incoming [StateBlocState]s with this [StateBloc]'s key.
  @protected
  final Observable<StateBlocState> blocStateObservable;

  ///@nodoc
  ///The [StreamSubscription] for the [stateQuery()] onData listener of the
  ///[stateQueryObservable].
  ///
  ///This [StreamSubscription] is cancelled in the [dispose()] method.
  StreamSubscription _stateQuerySubscription;

  ///@nodoc
  ///The [StreamSubscription] for the [setState()] onData listener of the
  ///[blocStateObservable].
  ///
  ///This [StreamSubscription] is cancelled in the [dispose()] method.
  StreamSubscription _blocStateSubscription;

  ///@nodoc
  ///Internal variable for the [dispatchState] getter and setter.
  bool _dispatchState;

  /*TODO: initialState should only be checked to see if it is valid AFTER
  the child constructor is finished. Otherwise the initialState will
  always be invalid as the fields have not yet been added to the map.
  The initial state should probably be checked and sent to setState when the
  bloc is registered with the Dispatcher via a special action.*/

  ///Creates an instance of this class with the unique identifier [key] and
  ///the input [actionObservable] from the [Dispather].
  ///
  ///An initialState can be set by specifiy [initialState]. The initial state
  ///must have the a [StateBlocState.blocKey] equal to [key]. All [FieldState]s
  ///in the initial state must also have [StateField]s in the [stateFieldMap]
  ///with equal [FieldID]s. The initial state of the registered [StateField]s
  ///will not be set until this is registered with a [Dispatcher].
  StateBlocImpl(String key, Observable<Action> actionObservable,
      {StateBlocState initialState, bool forceDispatch: false})
      : stateFieldMap = Map(),
        _forceDispatch = forceDispatch,
        _permanentForceDispatch = forceDispatch,
        _activeStateQueries = 0,
        _dispatchState = forceDispatch,
        stateQueryObservable = _createQueryObservable(actionObservable, key),
        blocStateObservable = _createStateObservable(actionObservable, key),
        super(key, actionObservable) {
    _createQuerySubscription();
    _createStateSubscription();
    if (initialState != null) {
      if (isBlocStateValid(initialState)) {
        setState(initialState);
      } else {
        throw InvalidStateBlocStateError(this, initialState);
      }
    }
  }

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
      throw ArgumentError(
          "activeStateQueries must be equal to or greater than 0."
          "\nactiveStateQueries: $activeStateQueries");
    }
  }

  ///Whether or not to dispatch new [StateBlocState]s.
  @protected
  bool get dispatchState => _dispatchState;

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
  set forceDispatch(bool forceDispatch) {
    _forceDispatch;
    _updateDispatchState();
  }

  ///Whether or not forceDispatch is permanently set to true.
  ///
  ///This will be true if forceDispatch was set to true in the constructor or
  ///[permanentForceDispatch] has been called one or more times.
  bool get isForceDispatchPermanent => _permanentForceDispatch;

  ///Returns the [FieldID]s of all registered [StateField]s.
  @override
  Iterable<FieldID> get stateFieldIDs => stateFieldMap.keys;

  ///Called when the value of dispatchState has changed.
  @protected
  @mustCallSuper
  void dispatchStateChanged() {
    //TODO: enable and disable state dispatching.
  }

  ///Call this method to perform clean up when this is no longer needed.
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    _stateQuerySubscription?.cancel();
    _blocStateSubscription?.cancel();
  }

  ///{@macro init}
  @protected
  @mustCallSuper
  @override
  void init(Action first) {
    super.init(first);
  }

  ///{macro invalid_state_fields}
  ///
  ///{@macro closed_state_error}
  ///
  ///{@macro field_state_match}
  @override
  Iterable<FieldID> invalidStateFields(StateBlocState blocState) {
    checkClosed();
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

  //TODO: register a listener on the actionObservable (before other listeners that effect state)
  //that calls a method to get the state of this bloc. State should only be sent
  //to stateUpdated if it is not the same as the previous state. This is required
  //as otherwise actions like fieldQueries would be considered statechanges.

  ///{@macro is_bloc_state_valid}
  ///
  ///{@macro closed_state_error}
  ///
  ///{@macro bloc_state_valid}
  @override
  bool isBlocStateValid(StateBlocState blocState) {
    checkClosed();
    return blocState.blocKey == key &&
        blocState.stateMap.keys.every((id) => stateFieldMap.keys.contains(id));
  }

  ///{@macro is_state_query_valid}
  ///
  ///{@macro closed_state_error}
  @override
  bool isStateQueryValid(StateQuery stateQuery) {
    checkClosed();
    return stateQuery.blocKey == key;
  }

  ///Permanently sets the value of [forceDispatch] to true.
  ///
  ///Any calls to the [forceDispatch] getter will be ignored after this.
  void permanentForceDispatch() {
    _permanentForceDispatch = true;
    _updateDispatchState();
  }

  ///Called when a BlocStateAction with the right key is recieved.
  @protected
  @mustCallSuper
  void setState(StateBlocState blocState) {}

  ///Called when a StateQueryAction with the right key is recieved.
  @protected
  @mustCallSuper
  void stateQuery(StateQuery stateQuery) {}

  ///Called when a new [StateBlocState] is avaliable.
  @protected
  @mustCallSuper
  void stateUpdated(StateBlocState stateBlocState) {}

  ///@nodoc
  ///Sets [_stateQuerySubscription] to the [StreamSubscription] returned when
  ///[stateQuery()] is added as an onData listener for the [stateQueryObservable].
  void _createQuerySubscription() =>
      _stateQuerySubscription = stateQueryObservable.listen(stateQuery);

  ///@nodoc
  ///Sets [_blocStateSubscription] to the [StreamSubscription] returned when
  ///[setState()] is added as an onData listener for the [blocStateObservable].
  void _createStateSubscription() =>
      _blocStateSubscription = blocStateObservable.listen(setState);

  ///@nodoc
  ///Sets the _dispatchState if it has changed as a result of a method call and
  ///calls [dispatchStateChanged()].
  ///
  ///Called by:
  ///1. [activeStateQueries]
  ///2. [forceDispatch]
  ///3. [permanentForceDispatch]
  void _updateDispatchState() {
    final bool newDispatchState = _activeStateQueries > 0 || _forceDispatch;
    if (_dispatchState != newDispatchState) {
      _dispatchState = newDispatchState;
      dispatchStateChanged();
    }
  }

  ///Creates the [stateQueryObservable].
  ///
  ///Operations:
  ///1. ```dart
  ///where((a) => a is StateQueryAction)
  ///```
  ///2. ```dart
  ///map<StateQuery>((a) => (a as StateQueryAction).stateQuery)
  ///```
  ///3. ```dart
  ///where((stateQuery) => stateQuery.blocKey == key)
  ///```
  static Observable<StateQuery> _createQueryObservable(
          Observable<Action> actionObservable, String key) =>
      actionObservable
          .where((a) => a is StateQueryAction)
          .map<StateQuery>((a) => (a as StateQueryAction).stateQuery)
          .where((stateQuery) => stateQuery.blocKey == key);

  ///Creates the [blocStateObservable].
  ///
  ///Operations:
  ///1. ```dart
  ///where((a) => a is BlocStateAction)
  ///```
  ///2. ```dart
  ///map<StateBlocState>((a) => (a as BlocStateAction).blocState)
  ///```
  ///3. ```dart
  ///where((blocState) => blocState.blocKey == key)
  ///```
  static Observable<StateBlocState> _createStateObservable(
          Observable<Action> actionObservable, String key) =>
      actionObservable
          .where((a) => a is BlocStateAction)
          .map<StateBlocState>((a) => (a as BlocStateAction).blocState)
          .where((blocState) => blocState.blocKey == key);
}
