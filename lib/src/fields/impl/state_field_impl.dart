import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../blocs/impl/state_bloc_impl.dart';
import '../../field_id.dart';
import '../../serializers.dart';
import '../../state/field_state.dart';
import '../field.dart';
import '../state_field.dart';
import 'field_impl.dart';

//TODO: add option to pass in state bloc to auto register
class StateFieldImpl<T> extends FieldImpl<T> implements StateField<T> {
  static const String stateFieldConcat = "_stateField";
  Field<FieldState<T>> _stateField;

  StateFieldImpl(String key, String blocKey, Observable<T> inputObservable,
      bool derived, StateBlocImpl stateBloc)
      : super(key, blocKey, inputObservable, derived, stateBloc) {
    isSerializable(T);
    final String keyConcat = key + stateFieldConcat;
    final String blocKeyConcat = blocKey + stateFieldConcat;
    _stateField = Field(
        keyConcat,
        blocKeyConcat,
        super.observable.map<FieldState<T>>((output) =>
            FieldState<T>(FieldID(keyConcat, blocKeyConcat), output)));
    if (stateBloc != null) {
      stateBloc.addStateField(this);
    }
  }

  ValueObservable<FieldState<T>> get fieldStateObservable =>
      stateField.observable;
  FieldState<T> get lastFieldState => stateField.lastValue;

  //TODO: document that T must be serializable.
  @protected
  Field<FieldState<T>> get stateField => _stateField;
}
