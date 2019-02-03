import 'package:rxdart/rxdart.dart';
import '../bloc.dart';
import '../../action/actions.dart';

//TODO: dispose should be called if the actionObservable finishes.

/*TODO: any methods in the interface for this bloc impl should be marked as
@mustCallSuper and there should be a check to make sure the bloc has not
yet had dispose called or have its actionObservable closed.*/

///An implementation of a bloc. Extend this for creating a bloc without any
///extra features.
abstract class BlocImpl implements Bloc {
  final String key;
  final Observable<Action> actionObservable;

  BlocImpl(this.key, this.actionObservable);

  void dispose();
}