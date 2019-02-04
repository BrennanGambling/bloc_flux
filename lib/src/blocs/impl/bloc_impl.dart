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

  ///@nodoc
  ///Internal variable for [isInitialized].
  ///
  ///Initially false but set to true when [init] is called.
  bool _init;

  ///The [Observable] carrying [Action]s from the dispatcher.
  final Observable<Action> actionObservable;

  ///@nodoc
  ///Internal variable for managing the closes state of this [Bloc].
  bool _closed;

  ///A map of all FieldIDs to Fields.
  @protected
  final Map<FieldID, Field> fieldMap;

  BlocImpl(this.key, this.actionObservable)
      : _closed = false,
        _init = false,
        fieldMap = Map() {
    actionObservable.listen(null, onDone: () => dispose());
    //When the first Action is received pass it to init.
    actionObservable.first.then(init);
  }

  ///True if [dispose] has been called or [actionObservable] has finished.
  bool get closed => _closed;

  ///Whether or not [init()] has been called.
  ///
  ///[init()] is called when the first [Action] is received from the
  ///[actionObservable].
  bool get isInitialized => _init;

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

  ///{@template dispose_impl}
  ///Perform clean up operations including calling dispose method of all
  ///registered [Field]s.
  ///
  ///If overriding this method super.dispose() must be called.
  ///{@endtemplate}
  ///
  ///{@template closed_state_error}
  ///**If this Bloc is already [closed] calling this method will result in a
  ///[StateError] being thrown.** For more information on when a [Bloc]
  ///is considered closed see [Bloc.closed].
  ///{@endtemplate}
  @mustCallSuper
  void dispose() {
    checkClosed();
    _closed = true;
    fieldMap.values.forEach((field) => field.dispose());
  }

  ///{@template init}
  ///This method is called when the first [Action] is received from [actionObservable].
  ///
  ///Override this method to perform any setup work here that cannot be
  ///performed in the constructor. An example of this would be initialization
  ///for components of a mixin. The mixin would just use the 'on BlocImpl'
  ///and override (and call the super) of init. This needs to be done as mixins
  ///do not have constructors.
  ///{@endtemplate}
  @mustCallSuper
  @protected
  void init(Action first) {
    _init = true;
  }
}
