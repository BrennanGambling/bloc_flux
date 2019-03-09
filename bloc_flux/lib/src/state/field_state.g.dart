// GENERATED CODE - DO NOT MODIFY BY HAND

part of field_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StateFieldState> _$stateFieldStateSerializer =
    _$StateFieldStateSerializer();

class _$StateFieldStateSerializer
    implements StructuredSerializer<StateFieldState> {
  @override
  final Iterable<Type> types = const [StateFieldState, _$StateFieldState];
  @override
  final String wireName = 'StateFieldState';

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
        ? StateFieldStateBuilder<Object>()
        : serializers.newBuilder(specifiedType) as StateFieldStateBuilder;

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

class _$StateFieldState<T> extends StateFieldState<T> {
  @override
  final T data;
  @override
  final FieldID fieldID;

  factory _$StateFieldState([void updates(StateFieldStateBuilder<T> b)]) =>
      (StateFieldStateBuilder<T>()..update(updates)).build();

  _$StateFieldState._({this.data, this.fieldID}) : super._() {
    if (fieldID == null) {
      throw BuiltValueNullFieldError('StateFieldState', 'fieldID');
    }
    if (T == dynamic) {
      throw BuiltValueMissingGenericsError('StateFieldState', 'T');
    }
  }

  @override
  StateFieldState<T> rebuild(void updates(StateFieldStateBuilder<T> b)) =>
      (toBuilder()..update(updates)).build();

  @override
  StateFieldStateBuilder<T> toBuilder() =>
      StateFieldStateBuilder<T>()..replace(this);

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
    return (newBuiltValueToStringHelper('StateFieldState')
          ..add('data', data)
          ..add('fieldID', fieldID))
        .toString();
  }
}

class StateFieldStateBuilder<T>
    implements Builder<StateFieldState<T>, StateFieldStateBuilder<T>> {
  _$StateFieldState<T> _$v;

  T _data;
  T get data => _$this._data;
  set data(T data) => _$this._data = data;

  FieldID _fieldID;
  FieldID get fieldID => _$this._fieldID;
  set fieldID(FieldID fieldID) => _$this._fieldID = fieldID;

  StateFieldStateBuilder();

  StateFieldStateBuilder<T> get _$this {
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
    _$v = other as _$StateFieldState<T>;
  }

  @override
  void update(void updates(StateFieldStateBuilder<T> b)) {
    if (updates != null) updates(this);
  }

  @override
  _$StateFieldState<T> build() {
    final _$result =
        _$v ?? _$StateFieldState<T>._(data: data, fieldID: fieldID);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
