import 'package:rxdart/rxdart.dart';
import 'action.dart';

///Extend to create Blocs for your project.
abstract class BaseBloc {
  ///A unique identifier for this instance of a subclass of BaseBloc.
  final String key;

  BaseBloc(this.key);

  ///Set the Action Observable to the dispatchers Action Observable.
  void setActionObservable(Observable<Action> observable);

  ///Set the initial state of the Bloc in this method.
  void initialize();

  ///Handle incoming Actions in this method.
  void handleAction(Action action);

  ///Release any resources in this method.
  void dispose();
}
