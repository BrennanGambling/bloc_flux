import 'package:meta/meta.dart';

///Extend this class to create Actions for your project.
@immutable
abstract class Action<T> {
  ///The Actions payload. If the Action does not require a payload this can be left null.
  final T data;

  Action({this.data});
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

@immutable
class InitialAction<T> extends Action<T> with ParentAction {

}