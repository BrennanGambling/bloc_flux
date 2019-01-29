import 'package:rxdart/rxdart.dart';

import '../action/field_actions.dart';
import '../field_id.dart';
import 'impl/field_impl.dart';

//TODO: add option to pass in bloc to auto register

class FieldView<T> {
  final Field<T> _field;

  ValueObservable<T> get observable => _field.observable;
  T get lastValue => _field.lastValue;

  FieldView(this._field);
}

///Represents a single output from a bloc.
abstract class Field<T> {
  ///A unique identifier for this field.
  String get key;

  FieldID get fieldID;

  ///true if the fields output is derived from the output of another field.
  bool get derived;

  ///the output observable of this field.
  ValueObservable<T> get observable;

  ///the last value emitted from [observable]
  T get lastValue;
  //add a value to the output stream.
  void add(T data);
  //dispose of resources.
  void dispose();
  //the observable that inputs to this field
  Observable<T> inputObservable;

  FieldValueAction<T> getTypedValueAction(T data);

  factory Field(String key, String blocKey, Observable<T> inputObservable,
          {bool derived: false}) =>
      FieldImpl<T>(key, blocKey, inputObservable, derived);
}
