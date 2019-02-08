import 'package:rxdart/rxdart.dart';

import '../action/field_actions.dart';
import '../bloc/impl/bloc_impl.dart';
import '../field_id.dart';
import 'impl/field_impl.dart';

/*TODO: should the Visitor pattern work for only allowing invocation of
getters with doc comment containing only_call_from_bloc from blocs?
If not add an analyzer plugin to check.*/

///A single unit of output from a [Bloc].
///
///This class is an interface for [FieldImpl] but should **only be implemented
///not extended** as it includes a factory constructor.
abstract class Field<T> {
  ///{@template field_constructor}
  ///Instantiates a [FieldImpl] with given parameters.
  ///
  ///A [bloc] can also be specified to automatically register this Field with
  ///it.
  ///
  ///If this [Field]s input is derived from the output of another [Field]
  ///set the [derived] optional to true (defaults to false).
  ///{@endtemplate}
  factory Field(String key, String blocKey, Observable<T> inputObservable,
          {bool derived: false, BlocImpl bloc}) =>
      FieldImpl<T>(key, blocKey, inputObservable, derived, bloc);

  ///{@template field_derived_getter}
  ///True if this [Fields] output is derived from the output of another [Field].
  ///{@endtemplate}
  ///
  ///{@template only_call_from_bloc}
  ///This method should only be called from inside of a [Bloc].
  ///{@endtemplate}
  bool get derived;

  ///{@template field_fieldID_getter}
  ///The [FieldID] for this [Field].
  ///
  ///This is derived from the [key] and [blocKey] provided to the constructor.
  ///
  ///[fieldID] should be unique. That is the [fieldID] of this [Field] should not
  ///be equal to the [fieldID] of any other [Field].
  ///{@endtemplate}
  FieldID get fieldID;

  ///{@template fieldView_getter}
  ///A [FieldView] of this [Field].
  ///{@endtemplate}
  ///
  ///{@macro only_call_from_bloc}
  FieldView<T> get fieldView;

  ///{@template field_lastValue_getter}
  ///The last/most current value emitted from [observable].
  ///{@endtemplate}
  T get lastValue;

  ///{@template field_observable_getter}
  ///The [Observable] carrying the output values of this [Field].
  ///
  ///The last value emitted from this [observable] will be emitted when this
  ///[Observable] has a new listener.
  ///{@endtemplate}
  ValueObservable<T> get observable;

  ///{@template field_add}
  ///Adds [data] to be emitted by [observable].
  ///{@endtemplate}
  ///
  ///{@macro only_call_from_bloc}
  void add(T data);

  ///{@template field_dispose}
  ///Perform any clean up operations.
  ///
  ///The [Field] can not be used in any way after calling this.
  ///{@endtemplate}
  ///
  ///{@macro only_call_from_bloc}
  void dispose();

  ///{@template get_value_action}
  ///Creates a [FieldValueAction] with the same generic type as this [Field] (T).
  ///
  ///This is done as accessing the generic parameters of an Object is not currently
  ///possible without reflection and the type is needed to be passed as a generic
  ///type when creating the [FieldValueAction].
  ///{@endtemplate}
  ///
  ///{@macro only_call_from_bloc}
  FieldValueAction<T> getTypedValueAction(T data);

  ///{@template is_valid_type}
  ///Whether or not [data]'s runtimeType is T or a subtype of T.
  ///{@endtemplate}
  ///
  ///{@macro only_call_from_bloc}
  bool isValidType(dynamic data);
}

///A wrapper for [Field] that does not expose memebers that should not be
///accessed outside of a [Bloc].
class FieldView<T> {
  ///@nodoc
  ///The [Field] that this [FieldView] is wrapping.
  final Field<T> _field;

  FieldView(this._field);

  ///{@macro field_fieldID_getter}
  FieldID get fieldID => _field.fieldID;

  ///{@macro field_lastValue_getter}
  T get lastValue => _field.lastValue;

  ///{@macro field_observable_getter}
  ValueObservable<T> get observable => _field.observable;
}
