import 'package:rxdart/rxdart.dart';

import '../bloc/impl/state_bloc_impl.dart';
import '../state/field_state.dart';
import 'field.dart';
import 'impl/state_field_impl.dart';

///A single unit of output from a [StateBloc] with added state management
///capabilities whe registered with a [StateBlocImpl].
///
///This class is an interface for [StateFieldImpl] and contains a factory
///constructor to instantiate one.
abstract class StateField<T> implements Field<T> {
  ///{@template state_field_constructor}
  ///Instantiates a [StateFieldImpl] with given parameters.
  ///
  ///A [stateBloc] can also be specified to automatically register this
  ///[StateField] with it.
  ///{@endtemplate}
  ///
  ///{@macro derived_parameter}
  factory StateField(String key, String blocKey, Observable<T> inputObservable,
          {bool derived: false, StateBlocImpl stateBloc}) =>
      StateFieldImpl(key, blocKey, inputObservable, derived, stateBloc);

  ///{@macro fieldStateObservable_getter}
  ///
  ///{@macro only_call_from_bloc}
  ValueObservable<FieldState<T>> get fieldStateObservable;

  ///{@macro lastFieldState_getter}
  ///
  ///{@macro only_call_from_bloc}
  FieldState<T> get lastFieldState;
}
