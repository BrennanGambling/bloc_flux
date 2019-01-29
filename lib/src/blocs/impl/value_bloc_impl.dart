import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../field_id.dart';
import '../../fields/field.dart';
import '../value_bloc.dart';
import 'bloc_impl.dart';

abstract class ValueBlocImpl extends BlocImpl implements ValueBloc {
  @protected
  final PublishSubject<Action> outputSubject;

  final Observable<Action> outputObservable;

  @protected
  final Map<FieldID, StreamSubscription<FieldValueAction>> fieldSubscriptionMap;

  @protected
  final Map<FieldID, Field> fieldMap;

  ValueBlocImpl(String key, Observable<Action> actionObservable)
      : this._(key, actionObservable, PublishSubject());

  ValueBlocImpl._(
      String key, Observable<Action> actionObservable, this.outputSubject)
      : outputObservable = outputSubject.stream,
        fieldSubscriptionMap = Map(),
        fieldMap = Map(),
        super(key, actionObservable);
}
