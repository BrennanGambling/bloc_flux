import 'package:rxdart/rxdart.dart';

import '../action/field_actions.dart';
import '../blocs/impl/bloc_impl.dart';
import '../field_id.dart';
import 'impl/field_impl.dart';

//TODO: add option to pass in bloc to auto register

///Represents a single output from a bloc.
abstract class Field<T> {
  Observable<T> inputObservable;

  factory Field(String key, String blocKey, Observable<T> inputObservable,
          {bool derived: false, BlocImpl bloc}) =>
      FieldImpl<T>(key, blocKey, inputObservable, derived, bloc);

  ///true if the fields output is derived from the output of another field.
  bool get derived;

  FieldID get fieldID;

  ///A unique identifier for this field.
  String get key;
  //add a value to the output stream.
  ///the last value emitted from [observable]
  T get lastValue;

  ///the output observable of this field.
  ValueObservable<T> get observable;

  void add(T data);

  //the observable that inputs to this field
  void dispose();

  FieldValueAction<T> getTypedValueAction(T data);

  ///{@template is_valid_type}
  ///Whether or not [data]'s runtimeType is T or a subtype of T.
  ///{@endtemplate}
  bool isValidType(dynamic data);
}

class FieldView<T> {
  final Field<T> _field;

  FieldView(this._field);
  T get lastValue => _field.lastValue;

  ValueObservable<T> get observable => _field.observable;
}
