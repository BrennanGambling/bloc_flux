import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../action/actions.dart';
import '../../action/field_actions.dart';
import '../../field_id.dart';
import '../../field_query.dart';
import '../../fields/field.dart';
import '../value_bloc.dart';
import 'bloc_impl.dart';

abstract class ValueBlocImpl extends BlocImpl implements ValueBloc {
  ///The subject that manages Action output to dispatcher.
  @protected
  final PublishSubject<Action> outputSubject;

  ///The observable for Action output to Dispatcher.
  @override
  final Observable<Action> outputObservable;

  ///A map of FieldIDs to StreamSubscriptions for currently subscribed fields.
  @protected
  final Map<FieldID, StreamSubscription<FieldValueAction>> fieldSubscriptionMap;

  ///A list of all active field queries
  @protected
  final List<FieldQuery> fieldQueries;

  //TODO: fieldMap should be moved to BlocImpl so any class extending BlocImpl
  //will have the stream of all of its fields closed when dispose is called.

  ///a map of all FieldIDs to Fields.
  @protected
  final Map<FieldID, Field> fieldMap;

  ///StreamSubscription for fieldQuery() onData listener.
  StreamSubscription _fieldQueryActionSubscription;

  ValueBlocImpl(String key, Observable<Action> actionObservable)
      : this._(key, actionObservable, PublishSubject());

  ValueBlocImpl._(
      String key, Observable<Action> actionObservable, this.outputSubject)
      : outputObservable = outputSubject.stream,
        fieldSubscriptionMap = Map(),
        fieldQueries = List(),
        fieldMap = Map(),
        super(key, actionObservable) {
    _fieldQueryActionSubscription = actionObservable
        .where(((a) => a is FieldQueryAction))
        .map<FieldQuery>((a) => (a as FieldQueryAction).fieldQuery)
        .listen(fieldQuery);
  }

  @override
  Iterable<FieldID> get fieldIDs => fieldMap.keys;

  @protected
  @mustCallSuper
  void addAction(Action action) {
    outputSubject.add(action);
  }

  @protected
  @mustCallSuper
  void addField(Field field) => fieldMap[field.fieldID] = field;

  @override
  @mustCallSuper
  void dispose() {
    _fieldQueryActionSubscription?.cancel();
  }

  ///This is called after [fieldQuery()] is called.
  @protected
  @mustCallSuper
  void fieldQueriesUpdated() {
    //Create a Set of all unique fieldIDs.
    final Set<FieldID> fieldIDSet = Set();
    fieldQueries.forEach((fq) {
      List<FieldID> fqFieldIds;
      if (fq.all) {
        fqFieldIds = fieldMap.keys.toList();
      } else {
        fqFieldIds = fq.fieldIDs.toList();
      }
      fieldIDSet.addAll(fqFieldIds);
    });

    //Create a Set of FieldIDs for Fields that need to be subscribed.
    final Set<FieldID> addSet = Set();
    addSet.addAll(
        fieldIDSet.where((fq) => !fieldSubscriptionMap.keys.contains(fq)));
    addSet.forEach((id) {
      final Field field = fieldMap[id];
      final Observable<FieldValueAction> observable =
          field.observable.map(field.getTypedValueAction);
      fieldSubscriptionMap[id] = observable.listen(addAction);
    });

    //Create a Set of FieldIDs for Fields that need their subscription cancelled.
    final Set<FieldID> removeSet = Set();
    removeSet.addAll(
        fieldSubscriptionMap.keys.where((fq) => !fieldIDSet.contains(fq)));
    removeSet.forEach((id) {
      fieldSubscriptionMap[id].cancel();
      fieldSubscriptionMap.remove(id);
    });
  }

  ///This method is called to add a FieldQuery to this ValueBloc via a
  ///[FieldQueryAction].
  @mustCallSuper
  void fieldQuery(FieldQuery fieldQuery) {
    //make sure all fields in FieldQuery are in this bloc.
    assert(isFieldQueryValid(fieldQuery));
    if (fieldQuery.single) {
      //if this is a one time request dispatch the lastValues for the specified Fields.
      fieldQuery.fieldIDs.forEach((id) {
        final Field field = fieldMap[id];
        addAction(field.getTypedValueAction(field.lastValue));
      });
    } else if (fieldQuery.cancel) {
      fieldQueries.remove(fieldQuery);
    } else {
      fieldQueries.add(fieldQuery);
    }
    fieldQueriesUpdated();
  }

  ///Returns a BuiltList of FieldIDs in [fieldQuery] not present in this [ValueBloc].
  ///
  ///An empty list will be returned if all [Field]s are valid.
  @override
  Iterable<FieldID> invalidFields(FieldQuery fieldQuery) {
    ListBuilder<FieldID> listBuilder = ListBuilder();
    fieldQuery.fieldIDs.forEach((fq) {
      if (!fieldMap.keys.contains(fq)) {
        listBuilder.add(fq);
      }
    });
    return listBuilder.build();
  }

  ///Check if all [Field]s specified are registered in this bloc.
  @override
  bool isFieldQueryValid(FieldQuery fieldQuery) =>
      fieldQuery.fieldIDs.every((id) => fieldMap.keys.contains(id));

  @protected
  @mustCallSuper
  void removeField(Field field) => fieldMap.remove(field.fieldID);
}
