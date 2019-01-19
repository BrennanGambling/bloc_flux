import 'package:meta/meta.dart';

//TODO: write proper documentation.

///Indicates that something that could potentially affect the application state.
///
///All [Action]s must either extend or implement this class.
///
///Contains an optional payload, [data] with any important information relating
///to the [Action]. If the [Action] does not require a payload data will be null.
@immutable
abstract class Action<T> {
  ///The payload. May be null.
  final T data;

  Action({this.data});
}

//action decorator adds an E error field.
//if the [action] has fields other than T data these can
//be accessed from the action itself.
@immutable
abstract class ErrorAction<T, E> implements Action<T> {
  final Action<T> action;
  final E error;

  //override the data field as this Action's data field will be null.
  //(it was not set with the super constructor.)
  ErrorAction(this.action, this.error);

  @override
  T get data => action.data;
}

//marker interface for actions dispatched from other blocs
@immutable
abstract class InternalAction<T> extends Action<T> {}

//an action that carries a value from another bloc.
//this value must not be null.
@immutable
abstract class ValueAction<T> extends Action<T> implements InternalAction<T> {
  ValueAction(T data)
      : assert(data != null, "T data must NOT be null."),
        super(data: data);
}
