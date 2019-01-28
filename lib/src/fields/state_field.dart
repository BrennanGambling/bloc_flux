//TODO: state field derived constructor
//if a state field is derived it converts the same data stored in another field.
//basically its input field will be the out put of another field

//the value im a derived state field will not be backed up or restored as it
//will be update when its parent field is updated.

import 'field.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../state/field_state.dart';
import '../serializers.dart';

abstract class StateField<T> implements Field<T> {
  ValueObservable<FieldState<T>> get fieldStateObservable;
  FieldState<T> get lastFieldState;
}

//TODO: add option to pass in state bloc to auto register
class StateFieldImpl<T> extends FieldImpl<T> implements StateField<T> {
  static const String stateFieldConcat = "_stateField";
  Field<FieldState<T>> _stateField;

  @protected
  Field<FieldState<T>> get stateField => _stateField;

  ValueObservable<FieldState<T>> get fieldStateObservable =>
      stateField.observable;
  FieldState<T> get lastFieldState => stateField.lastValue;

  //TODO: document that T must be serializable.
  StateFieldImpl(
      String key, String blocKey, Observable<T> inputObservable, bool derived)
      : super(key, blocKey, inputObservable, derived) {
    isSerializable(T);
    _stateField = Field(
        key + stateFieldConcat,
        blocKey + stateFieldConcat,
        super
            .observable
            .map<FieldState<T>>((output) => FieldState<T>(key, output)));
  }
}
