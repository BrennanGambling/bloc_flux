// GENERATED CODE - DO NOT MODIFY BY HAND

part of bloc_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BlocState> _$blocStateSerializer = new _$BlocStateSerializer();

class _$BlocStateSerializer implements StructuredSerializer<BlocState> {
  @override
  final Iterable<Type> types = const [BlocState, _$BlocState];
  @override
  final String wireName = 'BlocState';

  @override
  Iterable serialize(Serializers serializers, BlocState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'key',
      serializers.serialize(object.key, specifiedType: const FullType(String)),
      'stateMap',
      serializers.serialize(object.stateMap,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(FieldState)])),
    ];

    return result;
  }

  @override
  BlocState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BlocStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'key':
          result.key = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'stateMap':
          result.stateMap = serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(FieldState)
              ])) as BuiltMap;
          break;
      }
    }

    return result.build();
  }
}

class _$BlocState extends BlocState {
  @override
  final String key;
  @override
  final BuiltMap<String, FieldState> stateMap;

  factory _$BlocState([void updates(BlocStateBuilder b)]) =>
      (new BlocStateBuilder()..update(updates)).build();

  _$BlocState._({this.key, this.stateMap}) : super._() {
    if (key == null) {
      throw new BuiltValueNullFieldError('BlocState', 'key');
    }
    if (stateMap == null) {
      throw new BuiltValueNullFieldError('BlocState', 'stateMap');
    }
  }

  @override
  BlocState rebuild(void updates(BlocStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  BlocStateBuilder toBuilder() => new BlocStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlocState && key == other.key && stateMap == other.stateMap;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, key.hashCode), stateMap.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BlocState')
          ..add('key', key)
          ..add('stateMap', stateMap))
        .toString();
  }
}

class BlocStateBuilder implements Builder<BlocState, BlocStateBuilder> {
  _$BlocState _$v;

  String _key;
  String get key => _$this._key;
  set key(String key) => _$this._key = key;

  BuiltMap<String, FieldState> _stateMap;
  BuiltMap<String, FieldState> get stateMap => _$this._stateMap;
  set stateMap(BuiltMap<String, FieldState> stateMap) =>
      _$this._stateMap = stateMap;

  BlocStateBuilder();

  BlocStateBuilder get _$this {
    if (_$v != null) {
      _key = _$v.key;
      _stateMap = _$v.stateMap;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlocState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BlocState;
  }

  @override
  void update(void updates(BlocStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$BlocState build() {
    final _$result = _$v ?? new _$BlocState._(key: key, stateMap: stateMap);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
