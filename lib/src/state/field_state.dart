library field_state;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'field_state.g.dart';

abstract class FieldState<T>
    implements Built<FieldState<T>, FieldStateBuilder<T>> {
  String get key;

  T get data;

  //TODO: make sure to document the fact that an error will be
  //thrown if the Type T is not serializable.
  FieldState._() {
    isSerializable(T);
  }
  factory FieldState([updates(FieldStateBuilder<T> b)]) = _$FieldState<T>;
  static Serializer<FieldState> get serializer => _$fieldStateSerializer;
}
