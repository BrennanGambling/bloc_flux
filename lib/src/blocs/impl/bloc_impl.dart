import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../field_id.dart';
import '../../fields/field.dart';
import '../bloc.dart';

///An implementation of a bloc. Extend this for creating a bloc without any
///extra features.
abstract class BlocImpl implements Bloc {
  ///A unique identifier for the [Bloc].
  final String key;

  ///The [Observable] carrying [Action]s from the dispatcher.
  final Observable<Action> actionObservable;

  ///@nodoc
  ///Internal variable for managing the closes state of this [Bloc].
  bool _closed;

  ///a map of all FieldIDs to Fields.
  @protected
  final Map<FieldID, Field> fieldMap;

  BlocImpl(this.key, this.actionObservable)
      : _closed = false,
        fieldMap = Map() {
    actionObservable.listen(null, onDone: () => dispose());
  }

  ///True if [dispose] has been called or [actionObservable] has finished.
  bool get closed => _closed;

  ///If [closed] is equal to true a [StateError] is thrown.
  @protected
  void checkClosed() {
    if (closed) {
      throw StateError("This Bloc has already been closed.\n"
          "It is closed due to one of the following reasons:\n"
          "\t1. The dispose method has been called.\n"
          "\t2. The actiobObservable has finished.");
    }
  }

  ///Perform cleanup operations.
  ///
  ///{@macro closed_state_error}
  ///
  ///All registered [Field]s will have their [Field.dispose] methods called.
  ///
  ///If overriding this method super must be called.
  @mustCallSuper
  void dispose() {
    checkClosed();
    _closed = true;
    fieldMap.values.forEach((field) => field.dispose());
  }
}

///{@template closed_state_error}
///**If this Bloc is already [closed] calling this method will result in a
///[StateError] being thrown.** For more information on when a [Bloc]
///is considered closed see [Bloc.closed].
///{@endtemplate}
