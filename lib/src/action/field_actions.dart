import 'package:meta/meta.dart';

import '../field_id.dart';
import '../field_query.dart';
import 'actions.dart';

///Dispatch an instance of this [Action] to register a [FieldQuery].
///
///[fieldQuery]{@macro data_not_null}
@immutable
class FieldQueryAction extends Action<FieldQuery>
    implements QueryAction<FieldQuery> {
  ///[fieldQuery]{@macro data_not_null}
  FieldQueryAction(FieldQuery fieldQuery) : super(data: fieldQuery) {
    if (fieldQuery == null) {
      throw ArgumentError.notNull("fieldQuery must NOT be null.");
    }
  }

  ///Helper method for getting the [FieldQuery.blocKey] from [fieldQuery].
  String get blocKey => data.blocKey;

  ///Helper method for getting the [fieldQuery].
  FieldQuery get fieldQuery => data;
}

///A [ValueAction] indicating an update to a [Field] that a [FieldQuery]
///has been registered for.
///
///[fieldID]{@macro data_not_null}
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
}
