library field_state;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'field_state.g.dart';

///Contains the state of a [StateField].
abstract class FieldState<T>
    implements Built<FieldState<T>, FieldStateBuilder<T>> {
  String get key;

  T get data;

  //TODO: make sure to document the fact that an error will be
  //thrown if the Type T is not serializable.
  FieldState._() {
    isSerializable(T);
  }

  //TODO: add reference to the serializers class where the types that are
  //serializable is listed.

  ///Throws if [data] is not serializable.
  factory FieldState(String key, T data) => FieldState.fromBuilder((b) => b
    ..key = key
    ..data = data);

  ///Throws if [data] is not serializable.
  factory FieldState.fromBuilder([updates(FieldStateBuilder<T> b)]) =
      _$FieldState<T>;
  static Serializer<FieldState> get serializer => _$fieldStateSerializer;
}
