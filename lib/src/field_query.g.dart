// GENERATED CODE - DO NOT MODIFY BY HAND

part of field_query;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FieldQuery> _$fieldQuerySerializer = new _$FieldQuerySerializer();

class _$FieldQuerySerializer implements StructuredSerializer<FieldQuery> {
  @override
  final Iterable<Type> types = const [FieldQuery, _$FieldQuery];
  @override
  final String wireName = 'FieldQuery';

  @override
  Iterable serialize(Serializers serializers, FieldQuery object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'single',
      serializers.serialize(object.single, specifiedType: const FullType(bool)),
      'blocKey',
      serializers.serialize(object.blocKey,
          specifiedType: const FullType(String)),
    ];
    if (object.fieldKeys != null) {
      result
        ..add('fieldKeys')
        ..add(serializers.serialize(object.fieldKeys,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }

    return result;
  }

  @override
  FieldQuery deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FieldQueryBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'single':
          result.single = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'blocKey':
          result.blocKey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'fieldKeys':
          result.fieldKeys = serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList;
          break;
      }
    }

    return result.build();
  }
}

class _$FieldQuery extends FieldQuery {
  @override
  final bool single;
  @override
  final String blocKey;
  @override
  final BuiltList<String> fieldKeys;
  bool __subscription;

  factory _$FieldQuery([void updates(FieldQueryBuilder b)]) =>
      (new FieldQueryBuilder()..update(updates)).build();

  _$FieldQuery._({this.single, this.blocKey, this.fieldKeys}) : super._() {
    if (single == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'single');
    }
    if (blocKey == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'blocKey');
    }
  }

  @override
  bool get subscription => __subscription ??= super.subscription;

  @override
  FieldQuery rebuild(void updates(FieldQueryBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldQueryBuilder toBuilder() => new FieldQueryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldQuery &&
        single == other.single &&
        blocKey == other.blocKey &&
        fieldKeys == other.fieldKeys;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, single.hashCode), blocKey.hashCode), fieldKeys.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldQuery')
          ..add('single', single)
          ..add('blocKey', blocKey)
          ..add('fieldKeys', fieldKeys))
        .toString();
  }
}

class FieldQueryBuilder implements Builder<FieldQuery, FieldQueryBuilder> {
  _$FieldQuery _$v;

  bool _single;
  bool get single => _$this._single;
  set single(bool single) => _$this._single = single;

  String _blocKey;
  String get blocKey => _$this._blocKey;
  set blocKey(String blocKey) => _$this._blocKey = blocKey;

  BuiltList<String> _fieldKeys;
  BuiltList<String> get fieldKeys => _$this._fieldKeys;
  set fieldKeys(BuiltList<String> fieldKeys) => _$this._fieldKeys = fieldKeys;

  FieldQueryBuilder();

  FieldQueryBuilder get _$this {
    if (_$v != null) {
      _single = _$v.single;
      _blocKey = _$v.blocKey;
      _fieldKeys = _$v.fieldKeys;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldQuery other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FieldQuery;
  }

  @override
  void update(void updates(FieldQueryBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldQuery build() {
    final _$result = _$v ??
        new _$FieldQuery._(
            single: single, blocKey: blocKey, fieldKeys: fieldKeys);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
