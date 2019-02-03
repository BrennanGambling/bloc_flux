import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../field_id.dart';
import '../../fields/field.dart';
import '../bloc.dart';

//TODO: dispose should be called if the actionObservable finishes.

/*TODO: any methods in the interface for this bloc impl should be marked as
@mustCallSuper and there should be a check to make sure the bloc has not
yet had dispose called or have its actionObservable closed.*/

///An implementation of a bloc. Extend this for creating a bloc without any
///extra features.
abstract class BlocImpl implements Bloc {
  final String key;
  final Observable<Action> actionObservable;

  ///a map of all FieldIDs to Fields.
  @protected
  final Map<FieldID, Field> fieldMap;

  BlocImpl(this.key, this.actionObservable) : fieldMap = Map();

  ///Perform cleanup operations.
  ///
  ///All registered [Field]s will have their [Field.dispose] methods called.
  ///
  ///If overriding this method super must be called.
  @mustCallSuper
  void dispose() {
    fieldMap.values.forEach((field) => field.dispose());
  }
}
