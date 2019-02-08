import 'package:meta/meta.dart';

import '../field_id.dart';
import '../query/state_query.dart';
import '../state/bloc_state.dart';
import '../state/field_state.dart';
import 'value_bloc.dart';

///Error thrown when a [StateBlocState] [blocState] provided to [stateBloc]
///is invalid.
@immutable
class InvalidStateBlocStateError extends Error {
  ///The [StateBloc] provided with invalid [StateBlocState] [blocState].
  final StateBloc stateBloc;

  ///The invalid [StateBlocState].
  final StateBlocState blocState;

  ///An optional extra message with more details.
  final String extraMessage;

  ///True if this error was thrown because an invalid initial [StateBlocState]
  ///was provided.
  ///
  ///This is information is important as the initial [StateBlocState] is **not
  ///checked until the first [Action] is received.**
  final bool causedByInitialState;

  InvalidStateBlocStateError(this.stateBloc, this.blocState,
      {this.causedByInitialState: false, this.extraMessage});

  ///The [StateBloc.key] of the [StateBloc].
  String get blocKey => stateBloc.key;

  ///The [FieldID]s of the [StateField]s contained in the [StateBlocState] but
  ///not in the [StateBloc].
  Iterable<FieldID> get invalidFields =>
      stateBloc.invalidStateFields(blocState);

  ///True if the keys of the [StateBloc] and [StateBlocState] match.
  bool get keysMatch => blocKey == stateKey;

  ///The [StateBlocState.blocKey] of the [StateBlocState].
  String get stateKey => blocState.blocKey;

  @override
  String toString() {
    final StringBuffer stringBuffer = StringBuffer();
    if (keysMatch) {
      stringBuffer.writeln(
          "BlocState contain FieldStates with no matching StateFields in StateBloc.");
      if (extraMessage != null) {
        stringBuffer.writeln(extraMessage);
      }
      if (causedByInitialState) {
        stringBuffer.writeln(
            "This error was caused by an invalid initialState provided to a StateBloc.");
      }
      stringBuffer.writeln("FieldIDs of invalid FieldStates:");
      stringBuffer.writeAll(invalidFields, "\n");
    } else {
      stringBuffer.writeln("Keys for BlocState and StateBloc do not match.");
      stringBuffer.writeln("StateBloc key: $blocKey");
      stringBuffer.writeln("BlocState key: $stateKey");
    }
    return stringBuffer.toString();
  }
}

//TODO: for undo functionality what happens if an Action changes multiple
//fields and therefore multiple state changes.
//solution: save state everytime an event is added to the actionObservable.
//the next action wont be processed until all listeners on actionObservable have finished
//(sync)

///[StateBloc] interface. Extend this class to create an interface for a [StateBlocImpl].
///
///See [StateBlocImpl] for more information.
abstract class StateBloc extends ValueBloc {
  ///{@template state}
  ///Gets the current [StateBlocState] of this [StateBloc].
  ///{@endtemplate}
  StateBlocState get state;

  ///{@template stateFieldIDs_getter}
  ///[FieldID]s for all registered [StateField]s.
  ///{@endtemplate}
  Iterable<FieldID> get stateFieldIDs;

  ///{@template invalid_state_fields}
  ///Returns an [Iterable] of all of the [FieldID]s of the [FieldState]s  in
  ///[blocState] without a matching registered [StateField]
  ///
  ///**OR**
  ///
  ///All of the [FieldID]s in [blocState] if the [StateBlocState.blocKey] of
  ///[blocState] is not equal to [key].
  ///{@endtemplate}
  ///
  ///{@macro closed_state_error}
  ///
  ///{@template field_state_match}
  ///A [FieldState] and a [StateField] are considered matching if they have
  ///equal [FieldID]s.
  ///{@endtemplate}
  Iterable<FieldID> invalidStateFields(StateBlocState blocState);

  ///{@template is_bloc_state_valid}
  ///Returns whether or not [blocState] is valid for this [StateBloc].
  ///{@endtemplate}
  ///
  ///{@macro closed_state_error}
  ///
  ///{@template bloc_state_valid}
  ///A [StateBlocState] is considered valid if all of the [FieldState]s it
  ///contains have matching [StateField]s in this [StateBloc] and the
  ///[StateBlocState.blocKey] is equal to [key].
  ///
  ///The generic types of the [FieldState]s must also be the same type or a
  ///subtype of the matching [StateField]s generic type. This can be checked
  ///using the [Field.isValidType] method.
  ///{@endtemplate}
  ///
  ///{@macro field_state_match}
  bool isBlocStateValid(StateBlocState blocState);

  ///{@template is_state_query_valid}
  ///Checks if the [StateQuery.blocKey] is equal to [key].
  ///{@endtemplate}
  ///
  ///{@macro closed_state_error}
  bool isStateQueryValid(StateQuery stateQuery);
}
