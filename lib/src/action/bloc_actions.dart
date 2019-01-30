import 'package:meta/meta.dart';

import '../state/bloc_state.dart';
import '../state_query.dart';
import 'actions.dart';

///Dispatch an instance of this [Action] to set the state of a [StateBloc].
///
///DO NOT use this [Action] to communicate a state change. This [Action] SETS
///the state of a [StateBloc]. Use [BlocStateValueAction] to communicate a state
///change.
///
///[blocState] must NOT be null.
@immutable
class BlocStateAction extends Action<BlocState>
    implements QueryAction<BlocState> {
  ///[blocState] must NOT be null.
  BlocStateAction(BlocState blocState) : super(data: blocState) {
    if (blocState == null) {
      throw ArgumentError.notNull("blocState must not be null.");
    }
  }

  ///Helper method for getting the blocKey.
  String get blocKey => data.blocKey;

  ///Helper method for getting the blocState.
  BlocState get blocState => data;
}

///Dispatch an instance of this [Action] to communicate a state change in a
///[StateBloc].
///
///DO NOT use this [Action] to set the state of a [StateBloc]. This [Action]
///COMMUNICATES a state change. Use [BlocStateAction] to set the state of a
///[StateBloc].
///
///[blocState] must NOT be null.
@immutable
class BlocStateValueAction extends ValueAction<BlocState>
    implements QueryAction<BlocState> {
  ///blocState must NOT be null.
  BlocStateValueAction(BlocState blocState) : super(blocState);

  ///Helper method for getting the blocKey.
  String get blocKey => data.blocKey;

  ///Helper method for getting the blocState.
  BlocState get blocState => data;
}

///Dispatch an instance of this [Action] to register a [StateQuery].
///
///[stateQuery] must NOT be null.
@immutable
class StateQueryAction extends Action<StateQuery>
    implements QueryAction<StateQuery> {
  ///[stateQuery] must NOT be null.
  StateQueryAction(StateQuery stateQuery) : super(data: stateQuery) {
    if (stateQuery == null) {
      throw ArgumentError.notNull("stateQuery must not be null.");
    }
  }

  ///Helper method for getting the blocKey.
  String get blocKey => data.blocKey;

  ///Helper method for getting the stateQuery.
  StateQuery get stateQuery => data;
}
