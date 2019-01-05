import 'package:meta/meta.dart';

///A function that maps an Action into a different Action. This is intended
///to be used for stream transformations.
typedef ActionToAction = Action Function(Action action);
//typedef ActionToAction<T, R> = Action<R> Function(Action<T> action);
///A function that maps an Action into a value of type R. The is intended
///to be used for stream transformations.
typedef ActionToValue<R> = R Function(Action action);

///A function that maps a value of type T to a value of type R. This is
///intended to be used for stream transformations.
typedef ValueToValue<T, R> = R Function(T value);

///A function that maps a value of type T to a ValueAction. This is intended
///to be used for stream transformations.
typedef ValueToValueAction<T> = ValueAction Function(T value);

///Extend this class to create Actions.
@immutable
abstract class Action<T> {
  ///The Actions payload. If the Action does not require a payload this can be left null.
  final T data;

  Action({this.data});
}

///Extend this class to create an Action that notifies other Blocs about the
///updated value. This special Action is used to notify other blocs about value
///changes rather than them just listening to the value streams. This is done as
///the blocs should only have one input, an Action stream from the Dispatcher.
@immutable
abstract class ValueAction<T> extends Action<T> {
  ValueAction(T data)
      : assert(data != null),
        super(data: data);
}

//TODO: check if using a empty mixin as a kind of identifier is bad practice or if there is a better way to do this.
///This mixin indicates that an Action should be handled in the
///handleParentAction callback method of a StoreBloc rather than being passed
///down to the actionStream and handleAction callback method of a subclass.
mixin ParentAction {}

///Extend this for Actions that can have errors.
@immutable
abstract class ErrorAction<T, E> extends Action<T> {
  ///An object representing the error that occurred.
  final E error;

  ErrorAction({T data, this.error}): super(data: data);
}

//TODO: maybe remove this due to plans to initialize state in BaseBloc constructor.
@immutable
class InitialAction<T> extends Action<T> with ParentAction {

}