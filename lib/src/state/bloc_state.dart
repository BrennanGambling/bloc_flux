library bloc_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'field_state.dart';

part 'bloc_state.g.dart';

//TODO: add proper documentation.

abstract class BlocState implements Built<BlocState, BlocStateBuilder> {
  String get key;

  BuiltMap<String, FieldState> get stateMap;

  BlocState._();
  factory BlocState([updates(BlocStateBuilder b)]) = _$BlocState;
  static Serializer<BlocState> get serializer => _$blocStateSerializer;
}
