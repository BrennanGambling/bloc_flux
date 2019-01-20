library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/serializer.dart';
import 'state/bloc_state.dart';
import 'state/field_state.dart';

part 'serializers.g.dart';

//TODO: add proper documentation.

bool isSerializable(Type type, {bool shouldThrow: true}) {
  print(type);
  final bool serializable = serializers.serializerForType(type) != null || type == Object;
  if (!serializable && shouldThrow) {
    //TODO: add link to more information about this error.
    //basically that only the primitives, Built and BuiltCollections are serializable.
    throw StateError("Type: $type is not serializable");
  }
  return serializable;
}

@SerializersFor(const [
  BlocState,
  FieldState
])
final Serializers serializers = _$serializers;
final Serializers standardJSONSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();