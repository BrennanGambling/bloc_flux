import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc/impl/state_bloc_impl.dart';
import '../../field_id.dart';
import '../../serializers.dart';
import '../../state/field_state.dart';
import '../field.dart';
import '../state_field.dart';
import 'field_impl.dart';

///A single unit of output from a [StateBloc] with added state management
///capabilities whe registered with a [StateBlocImpl].
///
///This class is an interface for [StateFieldImpl] and contains a factory
///constructor to instantiate one.
class StateFieldImpl<T> extends FieldImpl<T> implements StateField<T> {
  static const String stateFieldConcat = "_stateField";
  Field<FieldState<T>> _stateField;

  StateFieldImpl(String key, String blocKey, Observable<T> inputObservable,
      bool derived, StateBlocImpl stateBloc)
      : super(key, blocKey, inputObservable, derived, stateBloc) {
    isSerializable(T);
    final String keyConcat = key + stateFieldConcat;
    _stateField = Field(
        keyConcat,
        blocKey,
        super.observable.map<FieldState<T>>((output) =>
            FieldState<T>(FieldID(keyConcat, blocKey), output)));
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
