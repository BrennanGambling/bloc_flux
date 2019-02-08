import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../field/field.dart';
import '../../field_id.dart';
import '../bloc.dart';

///The implementation for [Bloc]. Extend this class to create a basic [Bloc].
///
///{@template impl_needs_interface}
///An interface class that extends or implements [Bloc] should be created for
///every created subclass of [BlocImpl]. The interface is not required but
///prevents access from internal variables. See section at the bottom of
///[BlocImpl] class documentation for reasoning.
///{@endtemplate}
///
///{@template why_impl_class}
///Impls classes are used due to Dart's lack of protected variable. Any variables
///that are declared as public but aren't intended for use other than in subclasses
///are marked with the protected annotation. They can still be access but the
///analyzer will show warnings.
///{@endtemplate}
abstract class BlocImpl implements Bloc {
  ///{@template bloc_key_getter}
  ///A unique identifer for this [Bloc].
  ///{@endtemplate}
  final String key;

  ///@nodoc
  ///Internal variable for [isInitialized].
  ///
  ///Initially false but set to true when [init] is called.
  bool _init;

  ///{@template bloc_action_observable_getter}
  ///The [Observable] carrying [Action]s from the [Dispatcher].
  ///{@endtemplate}
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

  ///{@template bloc_closed_getter}
  ///True if this [Bloc] has been closed or [actionObservable] has finished.
  ///{@endtemplate}
  bool get closed => _closed;

  ///{@template field_ids_getter}
  ///[FieldID]s for all registered [Field]s.
  ///{@endtemplate}
  @override
  Iterable<FieldID> get fieldIDs => fieldMap.keys;

  ///Whether or not [init()] has been called.
  ///
  ///[init()] is called when the first [Action] is received from the
  ///[actionObservable].
  bool get isInitialized => _init;

  ///Adds [field] to [fieldMap].
  ///
  ///If a [Field] with the same [FieldID] as the [field] argument has
  ///already be added it will be replaced.
  @mustCallSuper
  void addField(Field field) => fieldMap[field.fieldID] = field;

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

  ///Removes the [Field] from [fieldMap] with the same [FieldID] as the
  ///[field] argument if it is present.
  @mustCallSuper
  void removeField(Field field) => fieldMap.remove(field.fieldID);
}
