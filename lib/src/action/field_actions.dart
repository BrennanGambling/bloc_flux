import 'package:meta/meta.dart';
import 'actions.dart';
import '../field_id.dart';
import '../field_query.dart';

///An [Action] indicating an update to a [Field] that a bloc is subscribed to.
@immutable
class FieldValueAction<T> extends ValueAction<T> {
  final FieldID fieldID;

  FieldValueAction(T data, this.fieldID) : super(data);
}

///An [Action] indicating a request for field subscriptions.
@immutable
class FieldQueryAction extends Action<FieldQuery> implements InternalAction<FieldQuery> {
  ///Helper method for getting the [FieldQuery]s blocKey.
  String get blocKey => data.blocKey;
  ///Helper method for getting the FieldQuery.
  FieldQuery get fieldQuery => data;

  FieldQueryAction(FieldQuery fieldQuery) : super(data: fieldQuery);
}