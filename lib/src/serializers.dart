library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'field_id.dart';
import 'state/bloc_state.dart';
import 'state/field_state.dart';

part 'serializers.g.dart';

//TODO: add proper documentation.

/*TODO: doc comment: When client is using built values make sure they use serializer instaniatition
statement

@SerializersFor(const [ExampleClass1, ExampleClass2])
final Serializers serializers = (_$serializers.toBuilder()..addAll(blocFluxSerializers.serializers)).build();
*/

@SerializersFor(const [StateBlocState, FieldState])
final Serializers blocFluxSerializers = _$blocFluxSerializers;

final Serializers standardJSONSerializers =
    (blocFluxSerializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
bool isSerializable(Type type, {bool shouldThrow: true}) {
  //TODO: make sure this works for Built class created outside of this package.
  final bool serializable =
      blocFluxSerializers.serializerForType(type) != null || type == Object;
  if (!serializable && shouldThrow) {
    //TODO: add link to more information about this error.
    //basically that only the primitives, Built and BuiltCollections are serializable.
    //TODO: use a custom error. Maybe also add analyzer warnings.
    throw StateError("Type: $type is not serializable");
  }
  return serializable;
}
