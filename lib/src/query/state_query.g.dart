// GENERATED CODE - DO NOT MODIFY BY HAND

part of state_query;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StateQuery> _$stateQuerySerializer = new _$StateQuerySerializer();

class _$StateQuerySerializer implements StructuredSerializer<StateQuery> {
  @override
  final Iterable<Type> types = const [StateQuery, _$StateQuery];
  @override
  final String wireName = 'StateQuery';

  @override
  Iterable serialize(Serializers serializers, StateQuery object,
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

    return result;
  }

  @override
  StateQuery deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StateQueryBuilder();

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
        case 'single':
          result.single = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$StateQuery extends StateQuery {
  @override
  final String blocKey;
  @override
  final bool cancel;
  @override
  final bool single;
  bool __subscription;

  factory _$StateQuery([void updates(StateQueryBuilder b)]) =>
      (new StateQueryBuilder()..update(updates)).build();

  _$StateQuery._({this.blocKey, this.cancel, this.single}) : super._() {
    if (blocKey == null) {
      throw new BuiltValueNullFieldError('StateQuery', 'blocKey');
    }
    if (cancel == null) {
      throw new BuiltValueNullFieldError('StateQuery', 'cancel');
    }
    if (single == null) {
      throw new BuiltValueNullFieldError('StateQuery', 'single');
    }
  }

  @override
  bool get subscription => __subscription ??= super.subscription;

  @override
  StateQuery rebuild(void updates(StateQueryBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  StateQueryBuilder toBuilder() => new StateQueryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StateQuery &&
        blocKey == other.blocKey &&
        single == other.single;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, blocKey.hashCode), single.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StateQuery')
          ..add('blocKey', blocKey)
          ..add('cancel', cancel)
          ..add('single', single))
        .toString();
  }
}

class StateQueryBuilder implements Builder<StateQuery, StateQueryBuilder> {
  _$StateQuery _$v;

  String _blocKey;
  String get blocKey => _$this._blocKey;
  set blocKey(String blocKey) => _$this._blocKey = blocKey;

  bool _cancel;
  bool get cancel => _$this._cancel;
  set cancel(bool cancel) => _$this._cancel = cancel;

  bool _single;
  bool get single => _$this._single;
  set single(bool single) => _$this._single = single;

  StateQueryBuilder();

  StateQueryBuilder get _$this {
    if (_$v != null) {
      _blocKey = _$v.blocKey;
      _cancel = _$v.cancel;
      _single = _$v.single;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StateQuery other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StateQuery;
  }

  @override
  void update(void updates(StateQueryBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$StateQuery build() {
    final _$result = _$v ??
        new _$StateQuery._(blocKey: blocKey, cancel: cancel, single: single);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
