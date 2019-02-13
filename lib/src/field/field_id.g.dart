// GENERATED CODE - DO NOT MODIFY BY HAND

part of field_id;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FieldID> _$fieldIDSerializer = new _$FieldIDSerializer();

class _$FieldIDSerializer implements StructuredSerializer<FieldID> {
  @override
  final Iterable<Type> types = const [FieldID, _$FieldID];
  @override
  final String wireName = 'FieldID';

  @override
  Iterable serialize(Serializers serializers, FieldID object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'blocKey',
      serializers.serialize(object.blocKey,
          specifiedType: const FullType(String)),
      'fieldKey',
      serializers.serialize(object.fieldKey,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  FieldID deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FieldIDBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'blocKey':
          result.blocKey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'fieldKey':
          result.fieldKey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FieldID extends FieldID {
  @override
  final String blocKey;
  @override
  final String fieldKey;

  factory _$FieldID([void updates(FieldIDBuilder b)]) =>
      (new FieldIDBuilder()..update(updates)).build();

  _$FieldID._({this.blocKey, this.fieldKey}) : super._() {
    if (blocKey == null) {
      throw new BuiltValueNullFieldError('FieldID', 'blocKey');
    }
    if (fieldKey == null) {
      throw new BuiltValueNullFieldError('FieldID', 'fieldKey');
    }
  }

  @override
  FieldID rebuild(void updates(FieldIDBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldIDBuilder toBuilder() => new FieldIDBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldID &&
        blocKey == other.blocKey &&
        fieldKey == other.fieldKey;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, blocKey.hashCode), fieldKey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldID')
          ..add('blocKey', blocKey)
          ..add('fieldKey', fieldKey))
        .toString();
  }
}

class FieldIDBuilder implements Builder<FieldID, FieldIDBuilder> {
  _$FieldID _$v;

  String _blocKey;
  String get blocKey => _$this._blocKey;
  set blocKey(String blocKey) => _$this._blocKey = blocKey;

  String _fieldKey;
  String get fieldKey => _$this._fieldKey;
  set fieldKey(String fieldKey) => _$this._fieldKey = fieldKey;

  FieldIDBuilder();

  FieldIDBuilder get _$this {
    if (_$v != null) {
      _blocKey = _$v.blocKey;
      _fieldKey = _$v.fieldKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldID other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FieldID;
  }

  @override
  void update(void updates(FieldIDBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldID build() {
    final _$result =
        _$v ?? new _$FieldID._(blocKey: blocKey, fieldKey: fieldKey);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
