//Library for the bloc_state file and its generated implementation file.
library bloc_state;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../field_id.dart';
import '../serializers.dart';
import 'field_state.dart';

part 'bloc_state.g.dart';
//The file generated by built_value.

//TODO: add list construtor as the key are already in the fieldstates.
//TODO: add the serializer examples and the [] fuctionality examples.
//TODO: add link to the example code file under each H1 header. Usage and Serializer.
//TODO: for the equality checks should the print statements be added or is this pointless as the full code will be linked in.
//TODO: use @template and @macro comment tags to insert the example for there specific constructor pages.
//TODO: update examples after change from String key to FieldID.

///Contains the [FieldState] of all of the registered [StateField]s in the
///[StateBloc] with a [Bloc.key] equal to [key].
///
///To get a specific [FieldState] use the list access operator with the
///[FieldState.key] as the parameter:
///```dart
///stateBlocState\[fieldState.key\];
///```
///The list access operator **CANNOT** be used to set or add [FieldState]s.
///
///To do use the [StateBlocState.fromBuilder()] constructor and set [stateMap].
///[stateMap] itself cannot be directly modified as it is a [BuiltMap] but a new
///one can be created by call the [BuiltMap.toBuilder()] function: d
///```dart
///(stateBlocState.stateMap.toBuilder()..add(fieldState)).build()
///```
///
///The [stateMap] can also be used to get a specific [FieldState].
@BuiltValue(nestedBuilders: false)
abstract class StateBlocState
    implements Built<StateBlocState, StateBlocStateBuilder> {
  ///The [Serializer] for this class.
  static Serializer<StateBlocState> get serializer =>
      _$stateBlocStateSerializer;

  ///Instaniates a [StateBlocState] from a collection.
  ///
  ///{@template blocKey_equal}
  ///[blocKey] will be equal to the [FieldID] of all of the [FieldState]s and [FieldID]s.
  ///{@endtemplate}
  ///
  ///{@macro xor_parameters}
  ///
  ///{@macro not_empty}
  ///
  ///{@macro list_equal_ids}
  ///
  ///{@macro map_equal_ids}
  factory StateBlocState(
          {BuiltMap<FieldID, FieldState> stateMap,
          BuiltList<FieldState> stateList}) =>
      StateBlocState.fromBuilder((b) {
        final bool stateMapNull = stateMap == null;
        final bool stateListNull = stateList == null;

        _parameterChecks(stateMap, stateList);

        if (!stateMapNull) {
          b.stateMap = stateMap;
        } else if (!stateListNull) {
          final MapBuilder<FieldID, FieldState> mapBuilder = MapBuilder();
          mapBuilder
              .addEntries(stateList.map((fd) => MapEntry(fd.fieldID, fd)));
          b.stateMap = mapBuilder.build();
        }
      });

  ///Deserializes a [String] using the [blocFluxSerializers] and the
  ///[JsonCodec.decode] method.
  ///
  ///{@macro serializers_diff}
  factory StateBlocState.deserialize(String serialized) => blocFluxSerializers
      .deserializeWith(StateBlocState.serializer, jsonDecode(serialized));

  factory StateBlocState.fromBuilder([updates(StateBlocStateBuilder b)]) =
      _$StateBlocState;

  ///Deserializes a [String] using the [standardJSONSerializers] and
  ///the [JsonCodec.decode()] method.
  ///
  ///{@macro serializers_diff}
  factory StateBlocState.fromJSON(String string) => standardJSONSerializers
      .deserializeWith(StateBlocState.serializer, json.decode(string));

  ///@nodoc
  ///Internal constructor.
  ///
  ///{@macro not_empty}
  ///
  ///{@macro map_equal_ids}
  StateBlocState._() {
    _internalParameterChecks(stateMap);
  }

  ///The key of the [StateBloc] that this [StateBlocState] represents.
  ///
  ///{@macro blocKey_equal}
  @memoized
  String get blocKey => stateMap.keys.first.blocKey;

  ///A [BuiltMap] of the [FieldState.key] to [FieldState]s.
  BuiltMap<FieldID, FieldState> get stateMap;

  ///Returns the [FieldState] associated with the [FieldState.key].
  FieldState operator [](FieldID fieldID) => stateMap[fieldID]; 

  ///Serializes a [StateBlocState] using the [blocFluxSerializers] and the
  ///[JsonCodec.encode()] method.
  ///
  ///{@macro serializers_diff}
  static String serialize(StateBlocState blocState) => jsonEncode(
      blocFluxSerializers.serializeWith(StateBlocState.serializer, blocState));

  ///Serializes a [StateBlocState] using the [standardJSONSerializers] and
  ///the [JsonCodec.encode()] method.
  ///
  ///{@macro serializers_diff}
  static String toJSON(StateBlocState blocState) =>
      json.encode(standardJSONSerializers.serialize(blocState));

  ///@nodoc
  ///Performs checks on parameters when a constructor is called.
  ///
  ///{@macro not_empty}
  ///
  ///{@template map_equal_ids}
  ///The [FieldID.blocKey] keys and [FieldState.fieldID.blocKey] of the [FieldState] values
  ///**MUST BE EQUAL**, other an [ArgumentError] will be thrown.
  ///{@endtemplate}
  static void _internalParameterChecks(BuiltMap<FieldID, FieldState> stateMap) {
    if (stateMap != null) {
      if (stateMap.isEmpty) {
        throw ArgumentError("stateMap cannot be empty.");
      }
      final String firstID = stateMap.keys.first.blocKey;
      stateMap.forEach((id, state) {
        if ((id.blocKey != firstID) || (state.fieldID.blocKey != firstID)) {
          throw ArgumentError(
              "All FieldID keys and FieldState.fieldID of FieldState values must be equal in stateMap.\n"
              "id: $id\n"
              "state.fieldID: ${state.fieldID}");
        }
      });
    }
  }

  ///@nodoc
  ///Performs checks on constructor parameters.
  ///
  ///{@template xor_parameters}
  ///Either [stateMap] **OR** [stateList] should be specified but **NOT BOTH**,
  ///otherwise an [ArgumentError] will be thrown.
  ///{@endtemplate}
  ///
  ///{@template not_empty}
  ///The specified collection ([stateMap] or [stateList]) **MUST NOT** be empty,
  ///otherwise an [ArgumentError] will be thrown.
  ///{@endtemplate}
  ///
  ///{@template list_equal_ids}
  ///The [FieldState.fieldID] of each of the [FieldState]s in [stateList] **MUST
  ///BE EQUAL**, otherwise an [ArgumentError] will be thrown.
  ///{@endtemplate}
  static void _parameterChecks(
      BuiltMap<FieldID, FieldState> stateMap, BuiltList<FieldState> stateList) {
    final bool stateMapNull = stateMap == null;
    final bool stateListNull = stateList == null;

    final bool bothNull = stateMapNull && stateListNull;
    final bool neitherNull = !stateMapNull && !stateListNull;

    if (bothNull || neitherNull) {
      throw ArgumentError(
          "Specifiy either stateMap or stateList. One must be specified.");
    }

    if (!stateListNull) {
      if (stateList.isEmpty) {
        throw ArgumentError("stateList cannot be empty.");
      }
      if (!stateList
          .every((state) => state.fieldID == stateList.first.fieldID)) {
        throw ArgumentError(
            "The FieldState.fieldIDs for each FieldState in stateList must be equal.");
      }
    }
  }
}
