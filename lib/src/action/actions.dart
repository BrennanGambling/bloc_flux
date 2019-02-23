import 'package:meta/meta.dart';

///Indicates that something that could potentially affect the application state.
///
///All [Action]s must either extend or implement this class.
///
///Contains an optional payload, [data] with any important information relating
///to the [Action]. If the [Action] does not require a payload data will be null.
@immutable
class Action<T> {
  ///The payload. May be null.
  final T data;

  Action({this.data});
}

///A Decorator for the [Action] class which indicates the request [Action]
///resulted in an error represented by [error].
///
///If the [ErrorAction] does not require a payload, [error] can be left null.
@immutable
class ErrorAction<T, E> implements Action<T> {
  ///The [Action<T>] to wrap.
  final Action<T> action;

  ///The error payload. May be null.
  final E error;

  ///Creates an [ErrorAction] wrapping [action] with payload [error].
  ErrorAction(this.action, this.error);

  ///The [data] payload from the wrapped [Action].
  ///
  ///This is [action]'s [data] field, not the superclass's [data] field.
  @override
  T get data => action.data;
}

///Marker interface indicating an [Action] was dispatched from another [Bloc].
///
///{@template dont_extend_super_not_called}
///**DO NOT** extend this class as the super classes [Action.data] field will be
///left null as the super constructor is not called.
///{@endtemplate}
@immutable
abstract class InternalAction<T> implements Action<T> {}

///Marker interface indicating an [Action] is related to the [StateQuery] or
///[FieldQuery] functionality.
///
///{@macro dont_extend_super_not_called}
@immutable
abstract class QueryAction<T> implements InternalAction<T> {}

///An [Action] indicating a new value from a [Field].
///
///[data]{@template data_not_null}&#8197;must **NOT** be null otherwise an ArgumentError will be thrown.{@endtemplate}
@immutable
class ValueAction<T> extends Action<T> implements InternalAction<T> {
  ///[data]{@macro data_not_null}
  ValueAction(T data) : super(data: data) {
    if (data == null) {
      throw ArgumentError.notNull("data must not be null.");
    }
  }
}
