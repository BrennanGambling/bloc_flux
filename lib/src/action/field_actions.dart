import 'package:meta/meta.dart';

import '../field_id.dart';
import '../field_query.dart';
import 'actions.dart';

///An [Action] indicating a request for field subscriptions.
@immutable
class FieldQueryAction extends Action<FieldQuery>
    implements QueryAction<FieldQuery> {
  FieldQueryAction(FieldQuery fieldQuery) : super(data: fieldQuery);

  ///Helper method for getting the [FieldQuery]s blocKey.
  String get blocKey => data.blocKey;

  ///Helper method for getting the FieldQuery.
  FieldQuery get fieldQuery => data;
}

///An [Action] indicating an update to a [Field] that a bloc is subscribed to.
@immutable
class FieldValueAction<T> extends ValueAction<T> implements QueryAction<T> {
  final FieldID fieldID;

  FieldValueAction(T data, this.fieldID) : super(data);
}
