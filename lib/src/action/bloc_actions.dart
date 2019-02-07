import 'package:meta/meta.dart';

import '../state/bloc_state.dart';
import '../query/state_query.dart';
import 'actions.dart';

///Dispatch an instance of this [Action] to set the state of the [StateBloc].
///
///**DO NOT** use this [Action] to communicate a state change. This [Action] **SETS**
///the state of a [StateBloc]. Use [BlocStateValueAction] to communicate a state
///change.
///
///[blocState]{@macro data_not_null}
@immutable
class BlocStateAction extends Action<StateBlocState>
    implements QueryAction<StateBlocState> {
  ///[blocState]{@macro data_not_null}
  BlocStateAction(StateBlocState blocState) : super(data: blocState) {
    if (blocState == null) {
      throw ArgumentError.notNull("blocState must not be null.");
    }
  }

  ///{@template blocKey_helper}
  ///Helper method for getting the [StateBlocState.blocKey] from [blocState].
  ///{@endtemplate}
  String get blocKey => data.blocKey;

  ///{@template blocState_helper}
  ///Helper method for getting the [blocState].
  ///{@endtemplate}
  StateBlocState get blocState => data;
}

///Dispatch an instance of this [Action] to communicate a state change in a
///[StateBloc].
///
///**DO NOT** use this [Action] to set the state of a [StateBloc]. This [Action]
///**COMMUNICATES** a state change. Use [BlocStateAction] to set the state of a
///[StateBloc].
///
///[blocState]{@macro data_not_null}
@immutable
class BlocStateValueAction extends ValueAction<StateBlocState>
    implements QueryAction<StateBlocState> {
  ///[blocState]{@macro data_not_null}
  BlocStateValueAction(StateBlocState blocState) : super(blocState);

  ///{@macro blocKey_helper}
  String get blocKey => data.blocKey;

  ///{@macro blocState_helper}
  StateBlocState get blocState => data;
}

///Dispatch an instance of this [Action] to register a [StateQuery].
///
///[stateQuery]{@macro data_not_null}
@immutable
class StateQueryAction extends Action<StateQuery>
    implements QueryAction<StateQuery> {
  ///[stateQuery]{@macro data_not_null}
  StateQueryAction(StateQuery stateQuery) : super(data: stateQuery) {
    if (stateQuery == null) {
      throw ArgumentError.notNull("stateQuery must NOT be null.");
    }
  }

  ///Helper method for getting the [StateQuery.blocKey] from [stateField].
  String get blocKey => data.blocKey;

  ///Helper method for getting the [stateQuery].
  StateQuery get stateQuery => data;
}
