import 'package:rxdart/rxdart.dart';
import '../bloc.dart';
import '../../action/actions.dart';

///An implementation of a bloc. Extend this for creating a bloc without any
///extra features.
abstract class BlocImpl implements Bloc {
  final String key;
  final Observable<Action> actionObservable;

  BlocImpl(this.key, this.actionObservable);

  void dispose();
}