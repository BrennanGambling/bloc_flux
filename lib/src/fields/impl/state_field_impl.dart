import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../serializers.dart';
import '../../state/field_state.dart';
import '../field.dart';
import '../state_field.dart';
import 'field_impl.dart';

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
