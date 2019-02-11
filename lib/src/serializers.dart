library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'field_id.dart';
import 'serializers/composite_serializers.dart';
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
final Serializers _blocFluxBaseSerializers = _$_blocFluxBaseSerializers;

CompositeSerializers _blocFluxSerializers = (CompositeSerializersBuilder()..addSerializers(_blocFluxBaseSerializers)).build();

CompositeSerializers _standardJSONSerializers;

///{@template works_non_generic}
///These Serializers
Serializers get blocFluxSerializers => _blocFluxSerializers;

Serializers get standardJSONSerializers {
  if (_standardJSONSerializers == null) {
    _updateSerializers((b) => b);
  }
  return _standardJSONSerializers;
}

void addBuilderFactory(FullType specifiedType, Function function) =>
    _updateSerializers((b) => b..addBuilderFactory(specifiedType, function));

void addPlugin(SerializerPlugin plugin) =>
    _updateSerializers((b) => b..addPlugin(plugin));

void addSerializer(Serializer serializer) =>
    _updateSerializers((b) => b..add(serializer));

void addSerializers(Serializers serializers) =>
    _updateSerializers((b) => b..addSerializers(serializers));

bool isSerializable(Type type, {bool shouldThrow: true}) {
  //TODO: make sure this works for Built class created outside of this package.
  //TODO: is the test for Object needed all.
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

void _updateSerializers(CompositeUpdates builderFunction) {
  final CompositeSerializersBuilder builder =
      builderFunction(_blocFluxSerializers.toBuilder());
  _blocFluxSerializers = builder.build();
  _standardJSONSerializers = (builder..addPlugin(StandardJsonPlugin())).build();
}
