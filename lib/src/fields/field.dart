import 'package:meta/meta.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../field_id.dart';

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

  factory Field(String key, String blocKey, Observable<T> inputObservable,
          {bool derived: false}) =>
      FieldImpl<T>(key, blocKey, inputObservable, derived);
}

class FieldImpl<T> implements Field<T> {
  @override
  final String key;

  @override
  final FieldID fieldID;

  @override
  final bool derived;

  @override
  final ValueObservable<T> observable;

  @override
  T get lastValue => subject.value;

  @protected
  final BehaviorSubject<T> subject;

  //Stream subscription managing the inputObserbable
  //this needs to be canceled when the inputObservable is changed.
  @protected
  StreamSubscription<T> inputSubscription;

  FieldImpl(String key, String blocKey, Observable<T> inputObservable, bool derived)
      : this._(key, FieldID(blocKey, key), inputObservable, BehaviorSubject(), derived);

  FieldImpl._(this.key, this.fieldID, this._inputObservable, this.subject, this.derived)
      : observable = subject.stream {
    inputObservableChanged();
  }

  //local input observable
  Observable<T> _inputObservable;

  Observable<T> get inputObservable => _inputObservable;
  set inputObservable(Observable<T> observable) {
    //when the observable is changed the old subscription needs to be cancelled
    //and a new one created.
    _inputObservable = observable;
    inputObservableChanged();
  }

  //override to preform other work when the input obersvable changes.
  @mustCallSuper
  @protected
  void inputObservableChanged() {
    //when the input observable changes the current subscription for the old
    //one needs to be canceled (if there was one) and the new one needs to be listened to.
    inputSubscription?.cancel();
    inputSubscription = _inputObservable.listen(subject.add);
  }

  void add(T data) => subject.add(data);

  @mustCallSuper
  void dispose() {
    inputSubscription?.cancel();
    subject.close();
  }
}
