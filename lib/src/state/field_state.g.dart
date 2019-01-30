// GENERATED CODE - DO NOT MODIFY BY HAND

part of field_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FieldState> _$fieldStateSerializer = new _$FieldStateSerializer();

class _$FieldStateSerializer implements StructuredSerializer<FieldState> {
  @override
  final Iterable<Type> types = const [FieldState, _$FieldState];
  @override
  final String wireName = 'FieldState';

  @override
  Iterable serialize(Serializers serializers, FieldState object,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = <Object>[
      'data',
      serializers.serialize(object.data, specifiedType: parameterT),
      'fieldID',
      serializers.serialize(object.fieldID,
          specifiedType: const FullType(FieldID)),
    ];

    return result;
  }

  @override
  FieldState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = isUnderspecified
        ? new FieldStateBuilder<Object>()
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

class _$FieldState<T> extends FieldState<T> {
  @override
  final T data;
  @override
  final FieldID fieldID;

  factory _$FieldState([void updates(FieldStateBuilder<T> b)]) =>
      (new FieldStateBuilder<T>()..update(updates)).build();

  _$FieldState._({this.data, this.fieldID}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('FieldState', 'data');
    }
    if (fieldID == null) {
      throw new BuiltValueNullFieldError('FieldState', 'fieldID');
    }
    if (T == dynamic) {
      throw new BuiltValueMissingGenericsError('FieldState', 'T');
    }
  }

  @override
  FieldState<T> rebuild(void updates(FieldStateBuilder<T> b)) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldStateBuilder<T> toBuilder() => new FieldStateBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldState &&
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
    implements Builder<FieldState<T>, FieldStateBuilder<T>> {
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
  void replace(FieldState<T> other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FieldState<T>;
  }

  @override
  void update(void updates(FieldStateBuilder<T> b)) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldState<T> build() {
    final _$result = _$v ?? new _$FieldState<T>._(data: data, fieldID: fieldID);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
