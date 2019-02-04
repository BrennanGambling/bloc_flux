import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/field_actions.dart';
import '../../field_id.dart';
import '../field.dart';

class FieldImpl<T> implements Field<T> {
  @override
  final String key;

  @override
  final FieldID fieldID;

  @override
  final bool derived;

  @override
  final ValueObservable<T> observable;

  @protected
  final BehaviorSubject<T> subject;

  @protected
  StreamSubscription<T> inputSubscription;

  Observable<T> _inputObservable;

  //Stream subscription managing the inputObserbable
  //this needs to be canceled when the inputObservable is changed.
  FieldImpl(
      String key, String blocKey, Observable<T> inputObservable, bool derived)
      : this._(key, FieldID(blocKey, key), inputObservable, BehaviorSubject(),
            derived);

  FieldImpl._(
      this.key, this.fieldID, this._inputObservable, this.subject, this.derived)
      : observable = subject.stream {
    inputObservableChanged();
  }

  Observable<T> get inputObservable => _inputObservable;

  //local input observable
  set inputObservable(Observable<T> observable) {
    //when the observable is changed the old subscription needs to be cancelled
    //and a new one created.
    _inputObservable = observable;
    inputObservableChanged();
  }

  @override
  T get lastValue => subject.value;
  void add(T data) => subject.add(data);

  ///{@macro add_dynamic}
  @override
  void addDynamic(dynamic data) {
    add(data as T);
  }

  @override
  @mustCallSuper
  void dispose() {
    inputSubscription?.cancel();
    subject.close();
  }

  //override to preform other work when the input obersvable changes.
  @override
  FieldValueAction<T> getTypedValueAction(T data) =>
      FieldValueAction<T>(data, this.fieldID);

  @mustCallSuper
  @protected
  void inputObservableChanged() {
    //when the input observable changes the current subscription for the old
    //one needs to be canceled (if there was one) and the new one needs to be listened to.
    inputSubscription?.cancel();
    inputSubscription = _inputObservable.listen(subject.add);
  }

  ///{@macro is_valid_type}
  @override
  bool isValidType(dynamic data) {
    try {
      data as T;
    } on CastError {
      return false;
    }
    return true;
  }
}
