//TODO: state field derived constructor
//if a state field is derived it converts the same data stored in another field.
//basically its input field will be the out put of another field

//the value im a derived state field will not be backed up or restored as it
//will be update when its parent field is updated.

import 'package:rxdart/rxdart.dart';

import '../state/field_state.dart';
import 'field.dart';
import 'impl/state_field_impl.dart';

abstract class StateField<T> implements Field<T> {
  ValueObservable<FieldState<T>> get fieldStateObservable;
  FieldState<T> get lastFieldState;

  factory StateField(String key, String blocKey, Observable<T> inputObservable,
          bool derived) =>
      StateFieldImpl(key, blocKey, inputObservable, derived);
}
