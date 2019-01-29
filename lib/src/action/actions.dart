import 'package:meta/meta.dart';
import '../field_id.dart';

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

//The Decorator pattern is used so any Action can be decorated as an ErrorAction
//without having to extend or implement this class.

///A Decorator for the [Action] class which indicates the request [Action]
///resulted in an error represented by [E] [error].
///
///If the [ErrorAction] does not require a payload [error] can be left null.
@immutable
abstract class ErrorAction<T, E> implements Action<T> {
  ///The [Action<T>] to wrap.
  final Action<T> action;

  ///The error payload. May be null.
  final E error;

  ///Creates an [ErrorAction] wrapping [Action] [action] with payload [error].
  ErrorAction(this.action, this.error);

  //data is overriden as the super constrctor is called implicitly with no
  //parameters meaning the super classes data field will always be null.

  ///The [data] payload from the wrapped [Action].
  @override
  T get data => action.data;
}

//TODO: add square brackets around bloc or whatever the final name for the
//most basic bloc class is.

///Marker interface indicating an [Action] was dispatched from another bloc.
///
///DO NOT extend this class because the super classes data field will be left
///null as the super constructor is not called.
///
///In the future this will be used to distinguish user or externally
///dispatched [Action]s for logging and state serialization purposes.
@immutable
abstract class InternalAction<T> extends Action<T> {}

//TODO: add square brackets around bloc or whatever the final name for the
//most basic bloc class is.

///An [Action] indicating a new value from a bloc.
///
///[data] must not be null.
@immutable
abstract class ValueAction<T> extends Action<T> implements InternalAction<T> {
  ValueAction(T data)
      : assert(data != null, "data must NOT be null."),
        super(data: data);
}
