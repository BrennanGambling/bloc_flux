import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../action/bloc_actions.dart';
import '../../field_id.dart';
import '../../fields/state_field.dart';
import '../../state/bloc_state.dart';
import '../../state/field_state.dart';
import '../../state_query.dart';
import '../state_bloc.dart';
import 'value_bloc_impl.dart';

//TODO: get list of fields fieldid

abstract class StateBlocImpl extends ValueBlocImpl implements StateBloc {
  ///The map of all [StateField] [FieldID]s to registered [StateField]s.
  @protected
  final Map<FieldID, StateField> stateFieldMap;

  ///A list of all active [StateQuery]s.
  @protected
  final List<StateQuery> stateQueries;

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

  ///The initial [StateBlocState] of this [StateBloc].
  ///
  ///If [initialState] was not specified in the constructor this will be null.
  final StateBlocState initialState;

  ///@nodoc
  ///Internal variable for [lastState].
  StateBlocState _lastState;

  ///@nodoc
  ///The [StreamSubscription] for the [stateQuery()] onData listener of the
  ///[stateQueryObservable].
  ///
  ///{@template is_canceled_in_dispose}
  ///This [StreamSubscription] is canceled in the [dispose()] method.
  ///{@endtemplate}
  StreamSubscription _stateQuerySubscription;

  ///@nodoc
  ///The [StreamSubscription] for the [setState()] onData listener of the
  ///[blocStateObservable].
  ///
  ///{@macro is_canceled_in_dispose}
  StreamSubscription _blocStateSubscription;

  ///@nodoc
  ///The [StreamSubscription] for the [_saveState()] onData listener of the
  ///[actionObservable].
  ///
  ///{@macro is_canceled_in_dispose}
  StreamSubscription _saveStateSubscription;

  ///@nodoc
  ///Internal variable for the [dispatchState] getter and setter.
  bool _dispatchState;

  ///Creates an instance of this class with the unique identifier [key] and
  ///the input [actionObservable] from the [Dispather].
  ///
  ///An initialState can be set by specifiy [initialState]. The initial state
  ///must have the a [StateBlocState.blocKey] equal to [key]. All [FieldState]s
  ///in the initial state must also have [StateField]s in the [stateFieldMap]
  ///with equal [FieldID]s. The initial state of the registered [StateField]s
  ///will not be set until this is registered with a [Dispatcher].
  StateBlocImpl(String key, Observable<Action> actionObservable,
      {this.initialState, bool forceDispatch: false})
      : stateFieldMap = Map(),
        stateQueries = List(),
        _forceDispatch = forceDispatch,
        _permanentForceDispatch = forceDispatch,
        _dispatchState = forceDispatch,
        stateQueryObservable = _createQueryObservable(actionObservable, key),
        blocStateObservable = _createStateObservable(actionObservable, key),
        super(key, actionObservable) {
    _createQuerySubscription();
    _createStateSubscription();
  }

  ///The number of [StateQueries] currently registered for this [StateBloc].
  ///
  ///Will always be greater than or equal to 0.
  int get activeStateQueries => stateQueries.length;

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

  ///The [StateBlocState] containing the [FieldState]s of all registered
  ///[StateField]s before the last [Action] was recieved.
  StateBlocState get lastState => _lastState;

  ///{@macro state}
  @override
  StateBlocState get state {
    final MapBuilder<FieldID, FieldState> mapBuilder = MapBuilder();
    stateFieldMap.forEach((id, field) => mapBuilder[id] = field.lastFieldState);
    return StateBlocState(key, mapBuilder.build());
  }

  ///Returns the [FieldID]s of all registered [StateField]s.
  @override
  Iterable<FieldID> get stateFieldIDs => stateFieldMap.keys;

  ///Register [stateField] with this [StateBlocImpl].
  ///
  ///[stateField] will **NOT** be added to [BlocImpl.fieldMap] if its
  ///[Field.fieldID] is already contained as a key. It can still be added
  ///(or overwritten) be calling [BlocImpl.addField].
  ///
  ///If [stateField] should **NOT** be added to the [BlocImpl.fieldMap] set
  ///[addToFieldMap] to false. When not specified it defaults to true.
  @mustCallSuper
  void addStateField(StateField stateField, {bool addToFieldMap: true}) {
    final FieldID fieldID = stateField.fieldID;
    stateFieldMap[fieldID] = stateField;
    if (!fieldMap.containsKey(fieldID) && addToFieldMap) {
      addField(stateField);
    }
  }

  ///Called when the value of dispatchState has changed.
  @protected
  @mustCallSuper
  void dispatchStateChanged() {}

  ///Call this method to perform clean up when this is no longer needed.
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    _saveStateSubscription?.cancel();
    _stateQuerySubscription?.cancel();
    _blocStateSubscription?.cancel();
  }

  ///{@macro init}
  @protected
  @mustCallSuper
  @override
  void init(Action first) {
    super.init(first);
    if (initialState != null) {
      if (isBlocStateValid(initialState)) {
        setState(initialState);
      } else {
        throw InvalidStateBlocStateError(this, initialState,
            causedByInitialState: true);
      }
    }
    /*
    This listener must be added last as all Fields must be able to handle
    the action before the state is saved. Saving before all Fields have the 
    chance to update would result in an inpartially updated state being saved.
    */
    _createSaveSubscription();
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

  ///{@macro is_bloc_state_valid}
  ///
  ///{@macro closed_state_error}
  ///
  ///{@macro bloc_state_valid}
  @override
  bool isBlocStateValid(StateBlocState blocState) {
    checkClosed();
    return blocState.blocKey == key &&
        blocState.stateMap.keys
            .every((id) => stateFieldMap.keys.contains(id)) &&
        blocState.stateMap.keys.every(
            (id) => stateFieldMap[id].isValidType(blocState.stateMap[id]));
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

  ///Removes [stateField] from this [StateBlocImpl].
  ///
  ///If [stateField] should **NOT** be removed from [BlocImpl.fieldMap] set
  ///[removeFromFieldMap] to false. When not specified it defaults to true.
  @mustCallSuper
  void removeStateField(StateField stateField,
      {bool removeFromFieldMap: true}) {
    final FieldID fieldID = stateField.fieldID;
    stateFieldMap.remove(fieldID);
    if (fieldMap.containsKey(fieldID) && removeFromFieldMap) {
      removeField(stateField);
    }
  }

  ///Called when a [BlocStateAction] with the right key is recieved.
  @protected
  @mustCallSuper
  void setState(StateBlocState blocState) {
    if (blocState == null || !isBlocStateValid(blocState)) {
      throw InvalidStateBlocStateError(this, blocState);
    } else {
      blocState.stateMap.forEach((id, state) {
        stateFieldMap[id].add(state.data);
        /*final StateField field = stateFieldMap[id];
        final dynamic data = state.data;
        if (field.isValidType(data)) {
          field.add(data);
        } else {
          throw InvalidStateBlocStateError(this, blocState,
              extraMessage: "Types for StateField: ${field.fieldID}\n"
                  "and FieldState: ${field.fieldID}\n"
                  "do not match.\n"
                  "${field.runtimeType}\n"
                  "${state}\n");
        }*/
      });
    }
  }

  ///Called when a StateQueryAction with the right key is recieved.
  @protected
  @mustCallSuper
  void stateQuery(StateQuery stateQuery) {
    if (stateQuery.single) {
      outputSubject.add(BlocStateValueAction(state));
    } else {
      if (stateQuery.cancel) {
        stateQueries.remove(stateQuery);
      } else {
        stateQueries.add(stateQuery);
      }
    }
    _updateDispatchState();
  }

  ///Called when a new [StateBlocState] is avaliable.
  @protected
  @mustCallSuper
  void stateUpdated(StateBlocState stateBlocState) {
    if (dispatchState) {
      outputSubject.add(BlocStateValueAction(stateBlocState));
    }
  }

  ///@nodoc
  ///Sets [_stateQuerySubscription] to the [StreamSubscription] returned when
  ///[stateQuery()] is added as an onData listener for the [stateQueryObservable].
  void _createQuerySubscription() =>
      _stateQuerySubscription = stateQueryObservable.listen(stateQuery);

  ///@nodoc
  ///Sets [_blocStateSubscription] to the [StreamSubscription] returned when
  ///[setState()] is added as an onData listener for the [blocStateObservable].

  ///@nodoc
  ///Sets [_saveStateSubscription] to the [StreamSubscription] returned when
  ///[_saveState()] is added as an onData listener for the [actionObservable].
  void _createSaveSubscription() =>
      _saveStateSubscription = actionObservable.listen((_) => _saveState());

  ///@nodoc
  ///Sets [_blocStateSubscription] to the [StreamSubscription] returned when
  ///[setState()] is added as an onData listener for the [blocStateObservable].
  void _createStateSubscription() =>
      _blocStateSubscription = blocStateObservable.listen(setState);

  ///@nodoc
  ///This method gets the current state from the [state] getter and compares
  ///it to the last saved state from the [lastState] getter.
  ///
  ///If the [StateBlocState]s are not equal [lastState] will be set to the
  ///current state and passed to the [stateUpdated] method.
  ///
  ///This method will always be called before any other listeners of
  ///[actionObservable] as it is registered before them. This means the state
  ///is saved **BEFORE** each field reacts to the [Action]. The state is only
  ///checked for differences once for each [Action] as the state can change
  ///multiple times in response to one [Action]. Having multiple state changes
  ///for one [Action] would make features like undo significantly harder to
  ///implement.
  void _saveState() {
    final StateBlocState newState = state;
    if (_lastState != newState) {
      _lastState = newState;
      stateUpdated(_lastState);
    }
  }

  ///@nodoc
  ///Sets the _dispatchState if it has changed as a result of a method call and
  ///calls [dispatchStateChanged()].
  ///
  ///Called by:
  ///1. [forceDispatch]
  ///2. [permanentForceDispatch]
  ///3. [stateQuery]
  void _updateDispatchState() {
    final bool newDispatchState = activeStateQueries > 0 || _forceDispatch;
    if (_dispatchState != newDispatchState) {
      _dispatchState = newDispatchState;
      dispatchStateChanged();
    }
  }

  ///@nodoc
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

  ///@nodoc
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
