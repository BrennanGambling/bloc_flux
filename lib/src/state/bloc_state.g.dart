// GENERATED CODE - DO NOT MODIFY BY HAND

part of bloc_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StateBlocState> _$stateBlocStateSerializer =
    new _$StateBlocStateSerializer();

class _$StateBlocStateSerializer
    implements StructuredSerializer<StateBlocState> {
  @override
  final Iterable<Type> types = const [StateBlocState, _$StateBlocState];
  @override
  final String wireName = 'StateBlocState';

  @override
  Iterable serialize(Serializers serializers, StateBlocState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'stateMap',
      serializers.serialize(object.stateMap,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(FieldID), const FullType(FieldState)])),
    ];

    return result;
  }

  @override
  StateBlocState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StateBlocStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'stateMap':
          result.stateMap = serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(FieldID),
                const FullType(FieldState)
              ])) as BuiltMap;
          break;
      }
    }

    return result.build();
  }
}

class _$StateBlocState extends StateBlocState {
  @override
  final BuiltMap<FieldID, FieldState> stateMap;
  String __blocKey;

  factory _$StateBlocState([void updates(StateBlocStateBuilder b)]) =>
      (new StateBlocStateBuilder()..update(updates)).build();

  _$StateBlocState._({this.stateMap}) : super._() {
    if (stateMap == null) {
      throw new BuiltValueNullFieldError('StateBlocState', 'stateMap');
    }
  }

  @override
  String get blocKey => __blocKey ??= super.blocKey;

  @override
  StateBlocState rebuild(void updates(StateBlocStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  StateBlocStateBuilder toBuilder() =>
      new StateBlocStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StateBlocState && stateMap == other.stateMap;
  }

  @override
  int get hashCode {
    return $jf($jc(0, stateMap.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StateBlocState')
          ..add('stateMap', stateMap))
        .toString();
  }
}

class StateBlocStateBuilder
    implements Builder<StateBlocState, StateBlocStateBuilder> {
  _$StateBlocState _$v;

  BuiltMap<FieldID, FieldState> _stateMap;
  BuiltMap<FieldID, FieldState> get stateMap => _$this._stateMap;
  set stateMap(BuiltMap<FieldID, FieldState> stateMap) =>
      _$this._stateMap = stateMap;

  StateBlocStateBuilder();

  StateBlocStateBuilder get _$this {
    if (_$v != null) {
      _stateMap = _$v.stateMap;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StateBlocState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StateBlocState;
  }

  @override
  void update(void updates(StateBlocStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$StateBlocState build() {
    final _$result = _$v ?? new _$StateBlocState._(stateMap: stateMap);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
