// GENERATED CODE - DO NOT MODIFY BY HAND

part of serializers;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$_blocFluxBaseSerializers = (new Serializers().toBuilder()
      ..add(FieldID.serializer)
      ..add(FieldQuery.serializer)
      ..add(FieldState.serializer)
      ..add(StateBlocState.serializer)
      ..add(StateQuery.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FieldID)]),
          () => new ListBuilder<FieldID>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(FieldID), const FullType(FieldState)]),
          () => new MapBuilder<FieldID, FieldState>()))
    .build();

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
