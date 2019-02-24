import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

///Indicates that something that could potentially affect the application state.
///
///All [Action]s must either extend or implement this class.
///
///Contains an optional payload, [data] with any important information relating
///to the [Action]. If the [Action] does not require a payload data will be null.
@immutable
class Action<T> {
  static const String _actionHash = "Action hash";

  ///The payload. May be null.
  final T data;

  const Action({this.data});

  ///The [hashCode] of an [Action] is derived from the [data] fields hashCode
  ///and the generic type parameter of this instance.
  @override
  int get hashCode => hash2((this?.data.hashCode ?? _actionHash.hashCode), T);

  ///[Action]s are equal if they both have equal generic type parameters (T) and
  ///[data] fields.
  @override
  bool operator ==(dynamic other) =>
      (other is Action<T>) && (this?.data == other?.data);
}

///A Decorator for the [Action] class which indicates the request [Action]
///resulted in an error represented by [error].
///
///If the [ErrorAction] does not require a payload, [error] can be left null.
@immutable
class ErrorAction<T, E> implements Action<T> {
  ///The [Action<T>] to wrap.
  ///
  ///{@template action_action_null}
  ///[action] must **NOT** be null.
  ///{@endtemplate}
  final Action<T> action;

  ///The error payload. May be null.
  final E error;

  ///Creates an [ErrorAction] wrapping [action] with payload [error].
  ///
  ///{@macro action_action_null}
  ErrorAction(this.action, this.error) {
    if (action == null) {
      throw ArgumentError.notNull("action must not be null.");
    }
  }

  ///The [data] payload from the wrapped [Action].
  ///
  ///This is [action]'s [data] field, not the superclass's [data] field.
  @override
  T get data => action.data;

  @override
  int get hashCode => hash2(action, error);

  ///[ErrorAction]s are equal if they both have equal generic type parameters (T and E)
  ///and their [action] and [error] fields are equal.
  @override
  bool operator ==(dynamic other) =>
      (other is ErrorAction<T, E>) &&
      (this.action == other.action) &&
      (this?.error == other?.error);
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

  ///The hashCode of a [ValueAction] is equal to the hashCode of [data].
  @override
  int get hashCode => data.hashCode;

  ///[ValueAction]s are equal if they have the same generic type parameters (T)
  ///and their [data] fields are equal.
  @override
  bool operator ==(dynamic other) =>
      (other is ValueAction<T>) && (this.data == other.data);
}
