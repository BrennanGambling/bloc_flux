import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';

typedef CompositeUpdates = CompositeSerializersBuilder Function(
    CompositeSerializersBuilder builder);

///A composite structure for the [Serializers] class.
///
///This class allows for a clients [Serializers] instance to be used along side
///this packages [Serializers] instance. This is important due to the fact that
///not all properties of [Serializers] can be copied (such as builder factories).
///It also means that clients do not have to individually add each [Serializer]
///and builder factory that the serialization methods in the state and query need
///access to.
///
///Because these method calls are applied to a collection of [Serializers] the
///behavior may be slightly different from the behavior when they are called
///on a single instance of [Serializers].
class CompositeSerializers implements Serializers {
  ///@nodoc
  ///The [Set] of [Serializers] instances that this [CompositeSerializers] represents.
  final BuiltSet<Serializers> _allSerializers;

  ///All of the [Serializer]s contained by this [CompositeSerializers] [Serializers].
  @override
  final Iterable<Serializer> serializers;

  ///Instaniates an instance of [CompositeSerializers] containing an instance
  ///of the default [Serializers].
  ///
  ///The default [Serializers] is the [Serializers] instance instaniated by the
  ///[Serializers] no parameter constructor. It will have [Serializer]s for primitive
  ///type and built collections such as [BuiltList].
  CompositeSerializers()
      : this._((SetBuilder<Serializers>()..add(Serializers())).build());

  ///@nodoc
  ///Internal constructor used to create the default [CompositeSerializers] and
  ///to create a [CompositeSerializers] instance when the build method is called
  ///on a [CompositeSerializersBuilder].
  CompositeSerializers._(BuiltSet<Serializers> serializers)
      : _allSerializers = _buildAllSerializers(serializers),
        serializers = _buildSerializers(serializers) {
    if (serializers == null) {
      throw ArgumentError.notNull("serializers must not be null.");
    } else if (serializers.isEmpty) {
      throw ArgumentError("serializers must not be empty.");
    }
  }

  ///Returns true if [Serilizers.hasBuilder()] returns true on **ALL** of the
  ///added [Serializers].
  ///
  ///To check if **ANY** of the add [Serializers] return true use [hasBuilder].
  bool allHaveBuilders(FullType fullType) =>
      _allSerializers.every((s) => s.hasBuilder(fullType));

  ///See [Serializers.deserialize()].
  ///
  ///Returns the result of calling [Serializers.deserialize] on the first instance
  ///of [Serializers] added to this [CompositeSerializers] that has a [Serializer]
  ///for [serialized].
  ///
  ///{@template same_full_type}
  ///The same FullType used to serialize an object must also be used to
  ///deserialize it, otherwise deserialization will fail.
  ///{@endtemplate}
  ///
  ///{@template serializer_lookup_method}
  ///The method for checking if each of the added [Serializers] has a [Serializer]
  ///for the object depends on whether or not [specifiedType] is unspecified,
  ///that is [specifiedType] equals FullType.unspecified.
  ///
  ///**** Specified
  ///  If the result of calling [Serialziers.serializerForType] with the FullType.root
  ///  of [specifiedType] is not null a [Serializer] was found.
  ///
  ///**** Unspecified
  ///  If the result of calling [Serializers.serializerForWireName] with the wire
  ///  name is not null a [Serializer] was found. The wire name is obtained by
  ///  casting the object to a List and then casting the first element to a String.
  ///
  ///If none of the [Serializers] have a [Serializer] for the object a StateError
  ///is thrown.
  ///{@endtemplate}
  ///
  ///If a [Serializers] had a [Serializer] but failed to deserialize [serialized],
  ///the last [Error] thrown (and caught) will be thrown.
  @override
  Object deserialize(Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    Error error;
    Object returnObject;
    bool found = false;
    bool success = false;
    _allSerializers.forEach((s) {
      if (success) {
        return;
      }
      try {
        if (!specifiedType.isUnspecified &&
            s.serializerForType(specifiedType.root) == null &&
            (serialized is List && serialized.first is String)) {
          returnObject = s.deserialize(serialized);
          success = true;
          return;
        } else {
          Serializer serializer;
          if (specifiedType.isUnspecified) {
            serializer =
                s.serializerForWireName((serialized as List).first as String);
          } else {
            serializer = s.serializerForType(specifiedType.root);
          }
          if (serializer != null) {
            found = true;
            returnObject =
                s.deserialize(serialized, specifiedType: specifiedType);
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
      throw StateError("No serializer for type: ${serialized.runtimeType}.");
    }
  }

  ///See [Serializers.deserializeWith()].
  ///
  ///Equivalent to calling [deserialize] with a [FullType] where [FullType.root]
  ///equals the first element in [Serializer.types] as the specifiedType.
  @override
  T deserializeWith<T>(Serializer<T> serializer, Object serialized) =>
      deserialize(serialized, specifiedType: FullType(serializer.types.first))
          as T;

  ///See [Serializers.expectBuilder()].
  ///
  ///Returns without throwing if **ANY** of the added [Serializer]s do not throw.
  ///
  ///To check if all added [Serializer]s have a builder for [fullType] use
  ///[allHaveBuilders] and throw if true is not returned.
  @override
  void expectBuilder(FullType fullType) {
    StateError stateError;
    bool found = false;
    _allSerializers.forEach((s) {
      if (found) {
        return;
      }
      try {
        s.expectBuilder(fullType);
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
    if (!found) {
      throw stateError;
    }
  }

  ///See [Serializers.hasBuilder()].
  ///
  ///Returns true if [Serializers.hasBuilder()] returns true on **ANY** of the
  ///added [Serializers].
  ///
  ///To check if **ALL** of the added [Serializers] return true use [allHaveBuilders].
  ///This is useful as serialization can still fail if a [Serializers] has a
  ///[Serializer] but not a builder factory.
  @override
  bool hasBuilder(FullType fullType) =>
      _allSerializers.any((s) => s.hasBuilder(fullType));

  ///See [Serializers.newBuilder]
  ///
  ///Returns the [Object] returned by first [Serializers] where [Serializers.hasBuilder()]
  ///returns true.
  ///
  ///If none of the [Serializers] have a builder factory for  [fullType] a [StateError]
  ///will be thrown.
  @override
  Object newBuilder(FullType fullType) {
    final StateError notFoundError =
        StateError("No builder factory for FullType: $fullType");
    if (hasBuilder(fullType)) {
      Object builder;
      Error error;
      bool found = false;
      _allSerializers.forEach((s) {
        if (found) {
          return;
        }
        try {
          if (s.hasBuilder(fullType)) {
            builder = s.newBuilder(fullType);
            found = true;
            return;
          }
        } catch (e) {
          //newBuilder should never throw if hasBuilder returns true but this has been added for safety.
          error = e;
        }
      });
      if (found) {
        return builder;
      } else if (error != null) {
        throw error;
      } else {
        throw notFoundError;
      }
    } else {
      throw notFoundError;
    }
  }

  ///See [Serializers.serialize()].
  ///
  ///Returns the result of calling [Serializers.serialize] on the first instance
  ///of [Serializers] added to this [CompositeSerializers] that has a [Serializer]
  ///for [object].
  ///
  ///{@macro same_full_type}
  ///
  ///{@macro serializer_lookup_method}
  ///
  ///If a [Serializers] had a [Serializer] but failed to serialize [object],
  ///the last [Error] thrown (and caught) will be thrown.
  @override
  Object serialize(Object object,
      {FullType specifiedType = FullType.unspecified}) {
    Error error;
    Object returnObject;
    bool found = false;
    bool success = false;
    _allSerializers.forEach((s) {
      if (success) {
        return;
      }
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

  ///See [Serializers.serializerForType()].
  ///
  ///Returns the [Serializer] from the first [Serializers] that returned a non
  ///null [Serializer] when [Serializers.serializerForType] was called on it.
  ///
  ///{@template null_serializer}
  ///If none of the [Serializers] returned a non null [Serializer] null will be
  ///returned.
  ///{@endtemplate}
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

  ///See [Serializers.serializerForWireName()].
  ///
  ///Returns the [Serializer] from the first [Serializers] that returned a non
  ///null [Serializer] when [Serializers.serializerForWireName] was called on it.
  ///
  ///{@macro null_serializer}
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

  ///See [Serializers.deserializeWith()].
  ///
  ///Equivalent to calling [serialize] with a [FullType] where [FullType.root]
  ///equalls the first element in [Serializer.types] as the specifiedType.
  @override
  Object serializeWith<T>(Serializer<T> serializer, T object) =>
      serialize(object, specifiedType: FullType(serializer.types.first));

  ///See [Serializers.toBuilder()].
  ///
  ///Returns a [CompositeSerializersBuilder] for this [CompositeSerializers].
  @override
  CompositeSerializersBuilder toBuilder() =>
      CompositeSerializersBuilder._(_allSerializers);

  ///@nodoc
  ///Internal method called by constructor build [_allSerializers]
  static BuiltSet<Serializers> _buildAllSerializers(
      Iterable<Serializers> serializers) {
    if (serializers == null) {
      return null;
    } else {
      return BuiltSet(serializers);
    }
  }

  ///@nodoc
  ///Internal method called by constructor to build [serializers].
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

///The builder for [CompositeSerializers].
class CompositeSerializersBuilder implements SerializersBuilder {
  ///@nodoc
  ///All added (including previously added) [Serializers] mapped to
  ///[SerializersBuilder]s.
  final Set<SerializersBuilder> _serializersSet;

  ///@nodoc
  ///All [Serializer]s from all added [Serializers].
  final Set<Serializer> _serializerSet;

  ///@nodoc
  ///All added builder factories.
  final Set<_BuilderFactoryPair> _builderFactorySet;

  ///@nodoc
  ///All added [SerializerPlugin]s.
  final Set<SerializerPlugin> _serializerPluginSet;

  ///Instaniates a new [CompositeSerializersBuilder].
  ///
  ///To get a builder for an existing [CompositeSerializers] call the
  ///[CompositeSerializers.toBuilder()] method.
  ///
  ///If no [Serializers] are added the default [Serializers] instance (the instance
  ///returned by call the no paramter [Serializers] constructor) will be added
  ///when [build()] is called.
  CompositeSerializersBuilder() : this._(BuiltSet());

  ///@nodoc
  ///Internal constructor for use by [CompositeSerializers].
  CompositeSerializersBuilder._(BuiltSet<Serializers> serializers)
      : _serializersSet =
            serializers.map<SerializersBuilder>((s) => s.toBuilder()).toSet(),
        _serializerSet = Set(),
        _builderFactorySet = Set(),
        _serializerPluginSet = Set() {
    serializers.forEach((s) => _serializerSet.addAll(s.serializers));
  }

  ///See [SerializersBuilder.add()].
  ///
  ///Adds [serializer] to all added [Serializers].
  @override
  void add(Serializer serializer) => _serializerSet.add(serializer);

  ///See [SerializersBuilder.addAll()].
  ///
  ///Adds all of the [Serializer]s in [serializers] to all added [Serializers].
  @override
  void addAll(Iterable<Serializer> serializers) =>
      _serializerSet.addAll(serializers);

  ///See [SerializersBuilder.addBuilderFactory()].
  ///
  ///Adds a builder function ([function]) for FullType [types] for all added
  ///[Serializers].
  @override
  void addBuilderFactory(FullType types, Function function) =>
      _builderFactorySet.add(_BuilderFactoryPair(types, function));

  ///See [SerializersBuilder.addPlugin()].
  ///
  ///Adds a [plugin] to all added [Serializers].
  @override
  void addPlugin(SerializerPlugin plugin) => _serializerPluginSet.add(plugin);

  ///Adds all of the [Serializer]s in [serializers] ([Serializers.serializers])
  ///to all of the [Serializers] added to this [CompositeSerializersBuilder].
  void addSerializers(Serializers serializers) {
    _serializersSet.add(serializers.toBuilder());
  }

  ///See [SerializersBuilder.build()].
  ///
  ///Builds this [CompositeSerializersBuilder] into a [CompositeSerializers].
  ///
  ///This is when all added [Serializer]s, [SerializerPlugin]s, and builder factories
  ///are added to all added [Serializers].
  ///
  ///If no [Serializers] have been added (or already existed) the default [Serializers]
  ///instance will be added.
  @override
  CompositeSerializers build() {
    if (_serializersSet.isEmpty) {
      _serializersSet.add(Serializers().toBuilder());
    }
    _serializersSet.forEach((sb) {
      sb.addAll(_serializerSet);
      _builderFactorySet
          .forEach((bf) => sb.addBuilderFactory(bf.specifiedType, bf.function));
      _serializerPluginSet.forEach(sb.addPlugin);
    });
    final BuiltSet<Serializers> builtSerializers =
        BuiltSet(_serializersSet.map<Serializers>((sb) => sb.build()));
    return CompositeSerializers._(builtSerializers);
  }
}

///@nodoc
///Internal value type for storage of builder factory variable.
@immutable
class _BuilderFactoryPair {
  final FullType specifiedType;
  final Function function;

  _BuilderFactoryPair(this.specifiedType, this.function);
}
