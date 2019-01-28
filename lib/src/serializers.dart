library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/serializer.dart';
import 'state/bloc_state.dart';
import 'state/field_state.dart';

part 'serializers.g.dart';

//TODO: add proper documentation.

bool isSerializable(Type type, {bool shouldThrow: true}) {
  //TODO: make sure this works for Built class created outside of this package.
  final bool serializable =
      serializers.serializerForType(type) != null || type == Object;
  if (!serializable && shouldThrow) {
    //TODO: add link to more information about this error.
    //basically that only the primitives, Built and BuiltCollections are serializable.
    //TODO: use a custom error. Maybe also add analyzer warnings.
    throw StateError("Type: $type is not serializable");
  }
  return serializable;
}

@SerializersFor(const [BlocState, FieldState])
final Serializers serializers = _$serializers;
final Serializers standardJSONSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
