import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc/impl/state_bloc_impl.dart';
import '../../serializers/serializers.dart';
import '../../state/field_state.dart';
import '../field.dart';
import '../field_id.dart';
import '../state_field.dart';
import 'field_impl.dart';

///A single unit of output from a [StateBloc] with added state management
///capabilities whe registered with a [StateBlocImpl].
///
///This class is an interface for [StateFieldImpl] and contains a factory
///constructor to instantiate one.
class StateFieldImpl<T> extends FieldImpl<T> implements StateField<T> {
  ///This is concatinated to the [key] passed to the [Field] constructor when
  ///instaniating [_stateField] ({@macro _stateField}]).
  static const String stateFieldConcat = "_stateField";

  ///@nodoc
  ///{@template _stateField}
  ///The internal [Field] managing the [StateFieldState].
  ///{@endtemplate}
  Field<StateFieldState<T>> _stateField;

  ///{@macro state_field_constructor}
  ///
  ///{@macro derived_parameter}
  StateFieldImpl(String key, String blocKey, Observable<T> inputObservable,
      bool derived, StateBlocImpl stateBloc)
      : super(key, blocKey, inputObservable, derived, stateBloc) {
    //TODO: add option to specify a FullType.
    isSerializable(type: T, shouldThrow: true);
    final String keyConcat = key + stateFieldConcat;
    _stateField = Field(
        keyConcat,
        blocKey,
        super.observable.map<StateFieldState<T>>((output) =>
            StateFieldState<T>(FieldID(keyConcat, blocKey), output)));
    if (stateBloc != null) {
      stateBloc.addStateField(this);
    }
  }

  ///{@template fieldStateObservable_getter}
  ///The [Observable] carrying the [StateFieldState]s derived from the output of this
  ///[StateField].
  ///{@endtemplate}
  ///
  ///{@macro only_call_from_bloc}
  ValueObservable<StateFieldState<T>> get fieldStateObservable =>
      stateField.observable;

  ///{@template lastFieldState_getter}
  ///The last value emitted from [fieldStateObservable].
  ///{@endtemplate}
  ///
  ///{@macro only_call_from_bloc}
  StateFieldState<T> get lastFieldState => stateField.lastValue;

  //TODO: document that T must be serializable.

  ///The [Field] managing the state of this [StateField].
  @protected
  Field<StateFieldState<T>> get stateField => _stateField;
}
