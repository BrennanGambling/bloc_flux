import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/field_actions.dart';
import '../../bloc/impl/bloc_impl.dart';
import '../../field_id.dart';
import '../field.dart';

///The implementation for [Field].
class FieldImpl<T> implements Field<T> {
  ///{@macro field_fieldID_getter}
  @override
  final FieldID fieldID;

  ///{@macro field_derived_getter}
  ///
  ///{@macro only_call_from_bloc}
  @override
  final bool derived;

  ///{@macro field_observable_getter}
  @override
  final ValueObservable<T> observable;

  ///The [BehvaiorSubject] managing [observable].
  @protected
  final BehaviorSubject<T> subject;

  ///@nodoc
  ///The [StreamSubscription] managing the [subject.add] onData listener
  ///added to the [inputObservable].
  @protected
  StreamSubscription<T> _inputSubscription;

  ///The [Observable] carrying input values.
  final Observable<T> inputObservable;

  ///@nodoc
  ///Internal [FieldView] created with this [FieldImpl] for use by the [fieldView]
  ///getter.
  ///
  ///This is set in the constructor.
  FieldView<T> _fieldView;

  ///{@macro field_constructor}
  FieldImpl(String key, String blocKey, Observable<T> inputObservable,
      bool derived, BlocImpl bloc)
      : this._(FieldID(blocKey, key), inputObservable, BehaviorSubject(),
            derived, bloc);

  FieldImpl._(this.fieldID, this.inputObservable, this.subject, this.derived,
      BlocImpl bloc)
      : observable = subject.stream {
    _createInputSubscription();
    if (bloc != null) {
      bloc.addField(this);
    }
    _fieldView = FieldView(this);
  }

  ///{@macro fieldView_getter}
  ///
  ///{@macro call_only_from_bloc}
  @override
  FieldView<T> get fieldView => _fieldView;

  ///{@macro field_lastValue_getter}
  @override
  T get lastValue => subject.value;

  ///{@macro field_add}
  ///
  ///{@macro field_add}
  @override
  void add(T data) => subject.add(data);

  ///{@macro field_dispose}
  ///
  ///{@macro only_call_from_bloc}
  @override
  @mustCallSuper
  void dispose() {
    _inputSubscription?.cancel();
    subject.close();
  }

  ///{@macro get_value_action}
  ///
  ///{@macro only_call_from_bloc}
  @override
  FieldValueAction<T> getTypedValueAction(T data) =>
      FieldValueAction<T>(data, this.fieldID);

  ///{@macro is_valid_type}
  ///
  ///{@macro only_call_from_bloc}
  @override
  bool isValidType(dynamic data) {
    try {
      data as T;
    } on CastError {
      return false;
    }
    return true;
  }

  ///@nodoc
  ///Creates the [_inputSubscription].
  void _createInputSubscription() {
    _inputSubscription = inputObservable.listen(subject.add);
  }
}
