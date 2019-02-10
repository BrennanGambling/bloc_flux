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
      'blocKey',
      serializers.serialize(object.blocKey,
          specifiedType: const FullType(String)),
      'cancel',
      serializers.serialize(object.cancel, specifiedType: const FullType(bool)),
      'single',
      serializers.serialize(object.single, specifiedType: const FullType(bool)),
    ];
    if (object.fieldIDs != null) {
      result
        ..add('fieldIDs')
        ..add(serializers.serialize(object.fieldIDs,
            specifiedType:
                const FullType(BuiltList, const [const FullType(FieldID)])));
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
        case 'blocKey':
          result.blocKey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'cancel':
          result.cancel = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'fieldIDs':
          result.fieldIDs = serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(FieldID)])) as BuiltList;
          break;
        case 'single':
          result.single = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$FieldQuery extends FieldQuery {
  @override
  final String blocKey;
  @override
  final bool cancel;
  @override
  final BuiltList<FieldID> fieldIDs;
  @override
  final bool single;
  bool __all;
  BuiltList<String> __fieldKeys;
  bool __subscription;

  factory _$FieldQuery([void updates(FieldQueryBuilder b)]) =>
      (new FieldQueryBuilder()..update(updates)).build();

  _$FieldQuery._({this.blocKey, this.cancel, this.fieldIDs, this.single})
      : super._() {
    if (blocKey == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'blocKey');
    }
    if (cancel == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'cancel');
    }
    if (single == null) {
      throw new BuiltValueNullFieldError('FieldQuery', 'single');
    }
  }

  @override
  bool get all => __all ??= super.all;

  @override
  BuiltList<String> get fieldKeys => __fieldKeys ??= super.fieldKeys;

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
        blocKey == other.blocKey &&
        fieldIDs == other.fieldIDs &&
        single == other.single;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, blocKey.hashCode), fieldIDs.hashCode), single.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldQuery')
          ..add('blocKey', blocKey)
          ..add('cancel', cancel)
          ..add('fieldIDs', fieldIDs)
          ..add('single', single))
        .toString();
  }
}

class FieldQueryBuilder implements Builder<FieldQuery, FieldQueryBuilder> {
  _$FieldQuery _$v;

  String _blocKey;
  String get blocKey => _$this._blocKey;
  set blocKey(String blocKey) => _$this._blocKey = blocKey;

  bool _cancel;
  bool get cancel => _$this._cancel;
  set cancel(bool cancel) => _$this._cancel = cancel;

  BuiltList<FieldID> _fieldIDs;
  BuiltList<FieldID> get fieldIDs => _$this._fieldIDs;
  set fieldIDs(BuiltList<FieldID> fieldIDs) => _$this._fieldIDs = fieldIDs;

  bool _single;
  bool get single => _$this._single;
  set single(bool single) => _$this._single = single;

  FieldQueryBuilder();

  FieldQueryBuilder get _$this {
    if (_$v != null) {
      _blocKey = _$v.blocKey;
      _cancel = _$v.cancel;
      _fieldIDs = _$v.fieldIDs;
      _single = _$v.single;
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
            blocKey: blocKey,
            cancel: cancel,
            fieldIDs: fieldIDs,
            single: single);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
