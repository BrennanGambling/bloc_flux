// GENERATED CODE - DO NOT MODIFY BY HAND

part of field_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StateFieldState> _$fieldStateSerializer = _$FieldStateSerializer();

class _$FieldStateSerializer implements StructuredSerializer<StateFieldState> {
  @override
  final Iterable<Type> types = const [StateFieldState, _$FieldState];
  @override
  final String wireName = 'FieldState';

  @override
  Iterable serialize(Serializers serializers, StateFieldState object,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = <Object>[
      'fieldID',
      serializers.serialize(object.fieldID,
          specifiedType: const FullType(FieldID)),
    ];
    if (object.data != null) {
      result
        ..add('data')
        ..add(serializers.serialize(object.data, specifiedType: parameterT));
    }

    return result;
  }

  @override
  StateFieldState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = isUnderspecified
        ? FieldStateBuilder<Object>()
        : serializers.newBuilder(specifiedType) as FieldStateBuilder;

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data =
              serializers.deserialize(value, specifiedType: parameterT);
          break;
        case 'fieldID':
          result.fieldID = serializers.deserialize(value,
              specifiedType: const FullType(FieldID)) as FieldID;
          break;
      }
    }

    return result.build();
  }
}

class _$FieldState<T> extends StateFieldState<T> {
  @override
  final T data;
  @override
  final FieldID fieldID;

  factory _$FieldState([void updates(FieldStateBuilder<T> b)]) =>
      (FieldStateBuilder<T>()..update(updates)).build();

  _$FieldState._({this.data, this.fieldID}) : super._() {
    if (fieldID == null) {
      throw BuiltValueNullFieldError('FieldState', 'fieldID');
    }
    if (T == dynamic) {
      throw BuiltValueMissingGenericsError('FieldState', 'T');
    }
  }

  @override
  StateFieldState<T> rebuild(void updates(FieldStateBuilder<T> b)) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldStateBuilder<T> toBuilder() => FieldStateBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StateFieldState &&
        data == other.data &&
        fieldID == other.fieldID;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, data.hashCode), fieldID.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldState')
          ..add('data', data)
          ..add('fieldID', fieldID))
        .toString();
  }
}

class FieldStateBuilder<T>
    implements Builder<StateFieldState<T>, FieldStateBuilder<T>> {
  _$FieldState<T> _$v;

  T _data;
  T get data => _$this._data;
  set data(T data) => _$this._data = data;

  FieldID _fieldID;
  FieldID get fieldID => _$this._fieldID;
  set fieldID(FieldID fieldID) => _$this._fieldID = fieldID;

  FieldStateBuilder();

  FieldStateBuilder<T> get _$this {
    if (_$v != null) {
      _data = _$v.data;
      _fieldID = _$v.fieldID;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StateFieldState<T> other) {
    if (other == null) {
      throw ArgumentError.notNull('other');
    }
    _$v = other as _$FieldState<T>;
  }

  @override
  void update(void updates(FieldStateBuilder<T> b)) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldState<T> build() {
    final _$result = _$v ?? _$FieldState<T>._(data: data, fieldID: fieldID);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
