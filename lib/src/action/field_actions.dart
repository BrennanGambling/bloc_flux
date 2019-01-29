import 'package:meta/meta.dart';
import 'actions.dart';
import '../field_id.dart';

///An [Action] indicating an update to a [Field] that a bloc is subscribed to.
@immutable
class FieldValueAction<T> extends ValueAction<T> {
  final FieldID fieldID;

  FieldValueAction(T data, this.fieldID) : super(data);
}