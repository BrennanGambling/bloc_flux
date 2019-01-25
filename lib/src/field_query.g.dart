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
      'fieldQuery',
      serializers.serialize(object.fieldQuery,
          specifiedType: const FullType(BuiltListMultimap,
              const [const FullType(String), const FullType(String)])),
      'blocKey',
      serializers.serialize(object.blocKey,
          specifiedType: const FullType(String)),
      'blocUri',
      serializers.serialize(object.blocUri, specifiedType: const FullType(Uri)),
      'fieldKeys',
      serializers.serialize(object.fieldKeys,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'fieldUris',
      serializers.serialize(object.fieldUris,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Uri)])),
    ];

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
        case 'fieldQuery':
          result.fieldQuery = serializers.deserialize(value,
              specifiedType: const FullType(BuiltListMultimap, const [
                const FullType(String),
                const FullType(String)
              ])) as BuiltListMultimap;
          break;
        case 'blocKey':
          result.blocKey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'blocUri':
          result.blocUri = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
        case 'fieldKeys':
          result.fieldKeys = serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList;
          break;
        case 'fieldUris':
          result.fieldUris = serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Uri)]))
              as BuiltList;
          break;
      }
    }

    return result.build();
  }
}

class _$FieldQuery extends FieldQuery {
  @override
  final BuiltListMultimap<String, String> fieldQuery;
  @override
  final String blocKey;
  @override
  final Uri blocUri;
  @override
  final BuiltList<String> fieldKeys;
  @override
  final BuiltList<Uri> fieldUris;

  factory _$FieldQuery([void updates(FieldQueryBuilder b)]) =>
      (new FieldQueryBuilder()..update(updates)).build();

  _$FieldQuery._(
      {this.fieldQuery,
      this.blocKey,
      this.blocUri,
      this.fieldKeys,
      this.fieldUris})
      : super._() {
    if (fieldQuery == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'fieldQuery');
    }
    if (blocKey == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'blocKey');
    }
    if (blocUri == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'blocUri');
    }
    if (fieldKeys == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'fieldKeys');
    }
    if (fieldUris == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'fieldUris');
    }
  }

  @override
  FieldQuery rebuild(void updates(FieldQueryBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldQueryBuilder toBuilder() => new FieldQueryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldQuery &&
        fieldQuery == other.fieldQuery &&
        blocKey == other.blocKey &&
        blocUri == other.blocUri &&
        fieldKeys == other.fieldKeys &&
        fieldUris == other.fieldUris;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, fieldQuery.hashCode), blocKey.hashCode),
                blocUri.hashCode),
            fieldKeys.hashCode),
        fieldUris.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldQuery')
          ..add('fieldQuery', fieldQuery)
          ..add('blocKey', blocKey)
          ..add('blocUri', blocUri)
          ..add('fieldKeys', fieldKeys)
          ..add('fieldUris', fieldUris))
        .toString();
  }
}

class FieldQueryBuilder implements Builder<FieldQuery, FieldQueryBuilder> {
  _$FieldQuery _$v;

  BuiltListMultimap<String, String> _fieldQuery;
  BuiltListMultimap<String, String> get fieldQuery => _$this._fieldQuery;
  set fieldQuery(BuiltListMultimap<String, String> fieldQuery) =>
      _$this._fieldQuery = fieldQuery;

  String _blocKey;
  String get blocKey => _$this._blocKey;
  set blocKey(String blocKey) => _$this._blocKey = blocKey;

  Uri _blocUri;
  Uri get blocUri => _$this._blocUri;
  set blocUri(Uri blocUri) => _$this._blocUri = blocUri;

  BuiltList<String> _fieldKeys;
  BuiltList<String> get fieldKeys => _$this._fieldKeys;
  set fieldKeys(BuiltList<String> fieldKeys) => _$this._fieldKeys = fieldKeys;

  BuiltList<Uri> _fieldUris;
  BuiltList<Uri> get fieldUris => _$this._fieldUris;
  set fieldUris(BuiltList<Uri> fieldUris) => _$this._fieldUris = fieldUris;

  FieldQueryBuilder();

  FieldQueryBuilder get _$this {
    if (_$v != null) {
      _fieldQuery = _$v.fieldQuery;
      _blocKey = _$v.blocKey;
      _blocUri = _$v.blocUri;
      _fieldKeys = _$v.fieldKeys;
      _fieldUris = _$v.fieldUris;
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
            fieldQuery: fieldQuery,
            blocKey: blocKey,
            blocUri: blocUri,
            fieldKeys: fieldKeys,
            fieldUris: fieldUris);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
