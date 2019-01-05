import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'action.dart';

///Extend to create Blocs for your project.
abstract class BaseBloc {
  ///A unique identifier for this instance of a subclass of BaseBloc.
  final String key;

  ///Indicates whether or not this BaseBloc has been initialized.
  bool _isInitialized = false;

  BaseBloc(this.key);

  ///Set the Action Observable to the dispatchers Action Observable.
  @mustCallSuper
  void setActionObservable(Observable<Action> observable) {
    _checkInitialized();
  }

  ///Initializes this BaseBloc if it has not been already.
  void _checkInitialized() {
    if (!_isInitialized) {
      initialize();
      _isInitialized = true;
    }
  }

  ///Set the initial state of the Bloc in this method.
  void initialize();

  ///Handle incoming Actions in this method.
  void handleAction(Action action);

  ///Release any resources in this method.
  void dispose();
}
