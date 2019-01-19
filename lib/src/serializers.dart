library serializers;

import 'package:built_value/serializer.dart';
import 'state/field_state.dart';

part 'serializers.g.dart';

//TODO: add proper documentation.

bool isSerializable(Type type, {bool shouldThrow: true}) {
  final bool serializable = serializers.serializerForType(type) != null;
  if (!serializable && shouldThrow) {
    //TODO: add link to more information about this error.
    //basically that only the primitives, Built and BuiltCollections are serializable.
    throw StateError("Type: $type is not serializable");
  }
  return serializable;
}

@SerializersFor(const [
  FieldState
])
final Serializers serializers = _$serializers;