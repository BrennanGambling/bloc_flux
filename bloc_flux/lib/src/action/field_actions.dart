import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../field/field_id.dart';
import '../query/field_query.dart';
import 'actions.dart';

///Dispatch an instance of this [Action] to register a [FieldQuery].
///
///[fieldQuery]{@macro data_not_null}
///{@category Actions}
@immutable
class FieldQueryAction extends Action<FieldQuery>
    implements QueryAction<FieldQuery> {
  ///[fieldQuery]{@macro data_not_null}
  FieldQueryAction(FieldQuery fieldQuery) : super(data: fieldQuery) {
    if (fieldQuery == null) {
      throw ArgumentError.notNull("fieldQuery must NOT be null.");
    }
  }

  ///Helper method for getting the [FieldQuery.all] from [fieldQuery].
  bool get all => data.all;

  ///Helper method for getting the [FieldQuery.blocKey] from [fieldQuery].
  String get blocKey => data.blocKey;

  ///Helper method for getting the [FieldQuery.cancel] from [fieldQuery].
  bool get cancel => data.cancel;

  ///Helper method for getting the [FieldQuery.fieldIDs] from [fieldQuery].
  BuiltList<FieldID> get fieldIDs => data.fieldIDs;

  ///Helper method for getting the [FieldQuery.fieldKeys] from [fieldQuery].
  BuiltList<String> get fieldKeys => data.fieldKeys;

  ///Helper method for getting the [fieldQuery].
  FieldQuery get fieldQuery => data;

  ///Helper method for getting the [FieldQuery.single] from [fieldQuery].
  bool get single => data.single;

  ///Helper method for getting the [FieldQuery.subscription] from [fieldQuery].
  bool get subscription => data.subscription;
}

///A [ValueAction] indicating an update to a [Field] that a [FieldQuery]
///has been registered for.
///
///[fieldID]{@macro data_not_null}
///{@category Actions}
@immutable
class FieldValueAction<T> extends ValueAction<T> implements QueryAction<T> {
  ///The [FieldID] of the [Field] that emitted [data].
  final FieldID fieldID;

  ///[fieldID]{@macro data_not_null}
  FieldValueAction(T data, this.fieldID) : super(data) {
    if (fieldID == null) {
      //TODO: check if it is possible to reach this statement as super constructor
      //will run first and should throw if fieldID == null.
      throw ArgumentError("fieldID must NOT be null.");
    }
  }

  @override
  int get hashCode => hash2(this.data, this.fieldID);

  @override
  bool operator ==(dynamic other) =>
      (other is FieldValueAction<T>) &&
      (this.data == other.data) &&
      (this.fieldID == other.fieldID);
}
