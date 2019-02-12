library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'field_id.dart';
import 'query/field_query.dart';
import 'query/state_query.dart';
import 'serializers/composite_serializers.dart';
import 'state/bloc_state.dart';
import 'state/field_state.dart';

part 'serializers.g.dart';

//TODO: doc comment: When client is using built values make sure they use serializer instaniatition
//statement
//@SerializersFor(const [ExampleClass1, ExampleClass2])
//final Serializers serializers = (_$serializers.toBuilder()..addAll(blocFluxSerializers.serializers)).build();

///@nodoc
///The [Serializers] for this package.
///
///Includes [Serializers] and builder factories needed for this package only.
@SerializersFor(
    const [FieldID, StateBlocState, FieldState, StateQuery, FieldQuery])
final Serializers _blocFluxBaseSerializers = _$_blocFluxBaseSerializers;

///@nodoc
///Internal variable for [blocFluxSerializers] getter.
///
///Initialized to a [CompositeSerializers] with [_blocFluxBaseSerializers] as
///an (and only) added [Serializers].
CompositeSerializers _blocFluxSerializers = (CompositeSerializersBuilder()
      ..addSerializers(_blocFluxBaseSerializers))
    .build();

///@nodoc
///Internal variable for [standardJsonSerializers] getter.
///
///Initialized in [_updateSerializers] if it is null when [standardJsonSerializers]
///is called. Also updated on every call to [_updateSerializers].
CompositeSerializers _standardJsonSerializers;

///Default [Serializers] for bloc_flux package.
///
///This is the [Serializers] instance that should be used in most cases. There
///is a second [Serializers] instance called [standardJsonSerializers] that includes
///the StandardJsonPlugin. For the differences between these two [Serializers]
///instances see the section at the bottom.
///
///{@template add_serializers}
///*** Add Custom [Serializers]
///If applicable add your own [Serializers] class using the [addSerializers()]
///method. This should be done as it allows for use of serialization methods
///built directly in to the state and query classes with custom [Built] objects
///and use of generics. See [addSerializers()] for more information.
///{@endtemplate}
///
///{@template serializers_diff}
///*** Differences Between Serializers
///[blocFluxSerializers] uses the ["default serialization format"](StandardJsonPlugin) which has
///["better performance and support for more collection types."](StandardJsonPlugin).
///
///[standardJsonSerializers] uses a ["simple map-based JSON"](StandardJsonPlugin) which
///most other systems use.
///
///If serialized values are only used within this project and are not deserialized
///by other serialization libraries [blocFluxSerializers] should be used. Otherwise
///use [standardJsonSerializers].
///{@endtemplate}
CompositeSerializers get blocFluxSerializers => _blocFluxSerializers;

///Standard JSON format [Serializers].
///
///This [Serializers] instance is identical to [blocFluxSerializers] with the
///[StandardJsonPlugin] added.
///
///This instance should be used if serialized values will be deserialized by other
///serialization libraries. The [blocFluxSerializers] should be used in most cases.
///For differences between the two [Serializers] instances see the section at
///the bottom.
///
///{@macro add_serializers}
///
///{@macro serializers_diff}
CompositeSerializers get standardJsonSerializers {
  if (_standardJsonSerializers == null) {
    _updateSerializers((b) => b);
  }
  return _standardJsonSerializers;
}

///Adds a builder factory to [blocFluxSerializers] and [standardJsonSerializers].
///
///{@template applied_to_all}
///This operation will also be applied to any [Serializers] already added using
///the [addSerializers] method. Any [Serializers] added after will **NOT** have this
///operation applied to them and should therefore be added using the [addSerializers()]
///method before this method is called.
///{@endtemplate}
void addBuilderFactory(FullType specifiedType, Function function) =>
    _updateSerializers((b) => b..addBuilderFactory(specifiedType, function));

///Adds a [SerializerPlugin] to [blocFluxSerializers] and [standardJsonSerializers]
///
///{@macro applied_to_all}
void addPlugin(SerializerPlugin plugin) =>
    _updateSerializers((b) => b..addPlugin(plugin));

///Adds a [Serializer] to [blocFluxSerializers] and [standardJsonSerializers].
///
///{@macro applied_to_all}
void addSerializer(Serializer serializer) =>
    _updateSerializers((b) => b..add(serializer));

///Adds a [Serializers] to [blocFluxSerializers] and [standardJsonSerializers].
///
///[blocFluxSerializers] and [standardJsonSerializers] are both [CompositeSerializers].
///A [CompositeSerializers] uses the Composite pattern to allow a collection of
///[Serializers] to act as a single [Serializers]. This allows for use of components
///of [Serializers] that cannot be copied (such as builder factories) by the
///bloc_flux [Serializers] instances. This is needed for some used cases of
///state and query classes built in serialization methods.
///
///See [CompositeSerializers] for more information.
void addSerializers(Serializers serializers) =>
    _updateSerializers((b) => b..addSerializers(serializers));

///Checks if [type] can be serialized using [blocFluxSerializers].
///
///If this method should throw when [type] is not serializable set [shouldThrow]
///to true (defaults to false).
///
///If [Object] should be considered a serializable [Type] set [objectIsSerializable]
///to true (defaults to false). This is needed in cases such as deserialization of
///objects with generic parameters as a Class<Object> is created and then cast to
///a Class<ActualType>.
bool isSerializable(Type type,
    {bool shouldThrow: false, bool objectIsSerializable: false}) {
  //TODO: make sure this works for Built class created outside of this package.
  //TODO: is the test for Object needed all.
  bool serializable;

  final bool serializerForType =
      blocFluxSerializers.serializerForType(type) != null ||
          (type == Object && objectIsSerializable);

  if (serializerForType) {
  } else {
    serializable = false;
  }

  if (!serializable && shouldThrow) {
    //TODO: add link to more information about this error.
    //basically that only the primitives, Built and BuiltCollections are serializable.
    //TODO: use a custom error. Maybe also add analyzer warnings.
    throw StateError("Type: $type is not serializable");
  }
  return serializable;
}

///@nodoc
///Updates rebuilds [_blocFluxSerializers] and [_standardJsonSerializers] after
///updates are applied via a [CompositeSerializersBuilder] in the [builderFunction].
///
///[builderFunction] is passed in an instance of a [CompositeSerializersBuilder]
///obtained from [_blocFluxSerializers].
///
///[_standardJsonSerializers] is also rebuilt using the builder returned from
///[builderFunction] after the [StandardJsonPlugin] is added to it.
void _updateSerializers(CompositeUpdates builderFunction) {
  final CompositeSerializersBuilder builder =
      builderFunction(_blocFluxSerializers.toBuilder());
  _blocFluxSerializers = builder.build();
  _standardJsonSerializers = (builder..addPlugin(StandardJsonPlugin())).build();
}
