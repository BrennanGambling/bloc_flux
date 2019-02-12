import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';

typedef CompositeUpdates = CompositeSerializersBuilder Function(
    CompositeSerializersBuilder builder);

class CompositeSerializers implements Serializers {
  final BuiltSet<Serializers> _allSerializers;

  @override
  final Iterable<Serializer> serializers;

  CompositeSerializers()
      : this._((SetBuilder<Serializers>()..add(Serializers())).build());

  CompositeSerializers._(BuiltSet<Serializers> serializers)
      : _allSerializers = _buildAllSerializers(serializers),
        serializers = _buildSerializers(serializers) {
    if (serializers == null) {
      throw ArgumentError.notNull("serializers must not be null.");
    } else if (serializers.isEmpty) {
      throw ArgumentError("serializers must not be empty.");
    }
  }

  Object deserialize(Object serialized,
      {FullType specifiedType: FullType.unspecified}) {
    Error error;
    Object returnObject;
    bool found = false;
    bool success = false;
    _allSerializers.forEach((s) {
      try {
        if (!specifiedType.isUnspecified &&
            s.serializerForType(specifiedType.root) == null &&
            (serialized is List && serialized.first is String)) {
              //use this class deserialize
          returnObject = s.deserialize(serialized);
          success = true;
          return;
        } else {
          Serializer serializer;
          if (specifiedType.isUnspecified) {
            serializer = s.serializerForWireName((serialized as List).first as String);
          } else {
            serializer = s.serializerForType(specifiedType.root);
          }
          if (serializer != null) {
            found = true;
            returnObject = s.deserialize(serialized, specifiedType: specifiedType);
            success = true;
          }
        }
        /*final String wireName = (serialized as List).first as String;

        if (serializerForWireName(wireName) != null) {
          found = true;
          returnObject =
              s.deserialize(serialized, specifiedType: specifiedType);
          success = true;
        }*/
      } catch (e) {
        error = e;
      }
    });
    if (success) {
      return returnObject;
    } else if (found) {
      throw error;
    } else {
      throw StateError("No serializer for type: ${serialized.runtimeType}.");
    }
  }

  T deserializeWith<T>(Serializer<T> serializer, Object serialized) =>
      deserialize(serialized, specifiedType: FullType(serializer.types.first))
          as T;

  void expectBuilder(FullType fullType) {
    StateError stateError;
    bool found = false;
    _allSerializers.forEach((s) {
      try {
        s.expectBuilder(fullType);
        found = true;
      } catch (e) {
        if (e is StateError) {
          stateError = e;
        } else {
          throw e;
        }
      }
    });
    if (!found) {
      throw stateError;
    }
  }

  bool hasBuilder(FullType fullType) =>
      _allSerializers.any((s) => s.hasBuilder(fullType));

  Object newBuilder(FullType fullType) {
    StateError stateError;
    Object object;
    bool found = false;
    _allSerializers.forEach((s) {
      try {
        object = s.newBuilder(fullType);
        found = true;
        return;
      } catch (e) {
        if (e is StateError) {
          stateError = e;
        } else {
          throw e;
        }
      }
    });
    if (found) {
      return object;
    } else {
      throw stateError;
    }
  }

  Object serialize(Object object,
      {FullType specifiedType: FullType.unspecified}) {
    Error error;
    Object returnObject;
    bool found = false;
    bool success = false;
    _allSerializers.forEach((s) {
      try {
        if (!specifiedType.isUnspecified &&
            s.serializerForType(specifiedType.root) == null) {
          //According to the comments in built_json_serializers.dart object
          //could be an interface in this case.
          returnObject = s.serialize(object);
          found = true;
          success = true;
          return;
        } else {
          Serializer serializer;
          if (specifiedType.isUnspecified) {
            serializer = s.serializerForType(object.runtimeType);
          } else {
            serializer = s.serializerForType(specifiedType.root);
          }
          if (serializer != null) {
            found = true;
            returnObject = s.serialize(object, specifiedType: specifiedType);
            success = true;
            return;
          }
        }
      } catch (e) {
        error = e;
      }
    });
    if (success) {
      return returnObject;
    } else if (found) {
      throw error;
    } else {
      throw StateError("No serializer for type: ${object.runtimeType}.");
    }
  }

  @override
  Serializer serializerForType(Type type) {
    Serializer serializer = null;
    _allSerializers.forEach((s) {
      final Serializer currentSerializer = s.serializerForType(type);
      if (currentSerializer != null) {
        serializer = currentSerializer;
        return;
      }
    });
    return serializer;
  }

  @override
  Serializer serializerForWireName(String wireName) {
    Serializer serializer = null;
    _allSerializers.forEach((s) {
      final Serializer currentSerializer = s.serializerForWireName(wireName);
      if (currentSerializer != null) {
        serializer = currentSerializer;
        return;
      }
    });
    return serializer;
  }

  Object serializeWith<T>(Serializer<T> serializer, T object) =>
      serialize(object, specifiedType: FullType(serializer.types.first));

  SerializersBuilder toBuilder() =>
      CompositeSerializersBuilder._(_allSerializers);

  static BuiltSet<Serializers> _buildAllSerializers(
      Iterable<Serializers> serializers) {
    if (serializers == null) {
      return null;
    } else {
      return BuiltSet(serializers);
    }
  }

  static BuiltSet<Serializer> _buildSerializers(
      Iterable<Serializers> serializers) {
    if (serializers == null) {
      return null;
    } else {
      final SetBuilder<Serializer> setBuilder = SetBuilder();
      serializers.forEach((s) => setBuilder.addAll(s.serializers));
      return setBuilder.build();
    }
  }
}

class CompositeSerializersBuilder implements SerializersBuilder {
  final Set<SerializersBuilder> _serializersSet;

  final List<Serializer> _serializerList;
  final List<_BuilderFactoryPair> _builderFactoryList;
  final List<SerializerPlugin> _serializerPluginList;

  CompositeSerializersBuilder() : this._(BuiltSet());

  CompositeSerializersBuilder._(BuiltSet<Serializers> serializers)
      : _serializersSet =
            serializers.map<SerializersBuilder>((s) => s.toBuilder()).toSet(),
        _serializerList = List(),
        _builderFactoryList = List(),
        _serializerPluginList = List();

  @override
  void add(Serializer serializer) => _serializerList.add(serializer);

  @override
  void addAll(Iterable<Serializer> serializers) =>
      _serializerList.addAll(serializers);

  @override
  void addBuilderFactory(FullType types, Function function) =>
      _builderFactoryList.add(_BuilderFactoryPair(types, function));

  @override
  void addPlugin(SerializerPlugin plugin) => _serializerPluginList.add(plugin);

  void addSerializers(Serializers serializers) =>
      _serializersSet.add(serializers.toBuilder());

  @override
  Serializers build() {
    if (_serializersSet.isEmpty) {
      _serializersSet.add(Serializers().toBuilder());
    }
    _serializersSet.forEach((sb) {
      sb.addAll(_serializerList);
      _builderFactoryList
          .forEach((bf) => sb.addBuilderFactory(bf.specifiedType, bf.function));
      _serializerPluginList.forEach(sb.addPlugin);
    });
    final BuiltSet<Serializers> builtSerializers =
        BuiltSet(_serializersSet.map<Serializers>((sb) => sb.build()));
    return CompositeSerializers._(builtSerializers);
  }
}

@immutable
class _BuilderFactoryPair {
  final FullType specifiedType;
  final Function function;

  _BuilderFactoryPair(this.specifiedType, this.function);
}
