// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<QuoteState> _$quoteStateSerializer = new _$QuoteStateSerializer();
Serializer<QuoteUIState> _$quoteUIStateSerializer =
    new _$QuoteUIStateSerializer();

class _$QuoteStateSerializer implements StructuredSerializer<QuoteState> {
  @override
  final Iterable<Type> types = const [QuoteState, _$QuoteState];
  @override
  final String wireName = 'QuoteState';

  @override
  Iterable<Object> serialize(Serializers serializers, QuoteState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(InvoiceEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  QuoteState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new QuoteStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'map':
          result.map.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(InvoiceEntity)
              ])));
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$QuoteUIStateSerializer implements StructuredSerializer<QuoteUIState> {
  @override
  final Iterable<Type> types = const [QuoteUIState, _$QuoteUIState];
  @override
  final String wireName = 'QuoteUIState';

  @override
  Iterable<Object> serialize(Serializers serializers, QuoteUIState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'listUIState',
      serializers.serialize(object.listUIState,
          specifiedType: const FullType(ListUIState)),
      'tabIndex',
      serializers.serialize(object.tabIndex,
          specifiedType: const FullType(int)),
    ];
    if (object.editing != null) {
      result
        ..add('editing')
        ..add(serializers.serialize(object.editing,
            specifiedType: const FullType(InvoiceEntity)));
    }
    if (object.selectedId != null) {
      result
        ..add('selectedId')
        ..add(serializers.serialize(object.selectedId,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  QuoteUIState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new QuoteUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(InvoiceEntity)) as InvoiceEntity);
          break;
        case 'listUIState':
          result.listUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ListUIState)) as ListUIState);
          break;
        case 'selectedId':
          result.selectedId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'tabIndex':
          result.tabIndex = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$QuoteState extends QuoteState {
  @override
  final BuiltMap<String, InvoiceEntity> map;
  @override
  final BuiltList<String> list;

  factory _$QuoteState([void Function(QuoteStateBuilder) updates]) =>
      (new QuoteStateBuilder()..update(updates)).build();

  _$QuoteState._({this.map, this.list}) : super._() {
    if (map == null) {
      throw new BuiltValueNullFieldError('QuoteState', 'map');
    }
    if (list == null) {
      throw new BuiltValueNullFieldError('QuoteState', 'list');
    }
  }

  @override
  QuoteState rebuild(void Function(QuoteStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuoteStateBuilder toBuilder() => new QuoteStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuoteState && map == other.map && list == other.list;
  }

  int __hashCode;
  @override
  int get hashCode {
    return __hashCode ??= $jf($jc($jc(0, map.hashCode), list.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('QuoteState')
          ..add('map', map)
          ..add('list', list))
        .toString();
  }
}

class QuoteStateBuilder implements Builder<QuoteState, QuoteStateBuilder> {
  _$QuoteState _$v;

  MapBuilder<String, InvoiceEntity> _map;
  MapBuilder<String, InvoiceEntity> get map =>
      _$this._map ??= new MapBuilder<String, InvoiceEntity>();
  set map(MapBuilder<String, InvoiceEntity> map) => _$this._map = map;

  ListBuilder<String> _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String> list) => _$this._list = list;

  QuoteStateBuilder();

  QuoteStateBuilder get _$this {
    if (_$v != null) {
      _map = _$v.map?.toBuilder();
      _list = _$v.list?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuoteState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$QuoteState;
  }

  @override
  void update(void Function(QuoteStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$QuoteState build() {
    _$QuoteState _$result;
    try {
      _$result =
          _$v ?? new _$QuoteState._(map: map.build(), list: list.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'QuoteState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$QuoteUIState extends QuoteUIState {
  @override
  final InvoiceEntity editing;
  @override
  final int editingItemIndex;
  @override
  final String historyActivityId;
  @override
  final ListUIState listUIState;
  @override
  final String selectedId;
  @override
  final int tabIndex;
  @override
  final Completer<SelectableEntity> saveCompleter;
  @override
  final Completer<Null> cancelCompleter;

  factory _$QuoteUIState([void Function(QuoteUIStateBuilder) updates]) =>
      (new QuoteUIStateBuilder()..update(updates)).build();

  _$QuoteUIState._(
      {this.editing,
      this.editingItemIndex,
      this.historyActivityId,
      this.listUIState,
      this.selectedId,
      this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    if (listUIState == null) {
      throw new BuiltValueNullFieldError('QuoteUIState', 'listUIState');
    }
    if (tabIndex == null) {
      throw new BuiltValueNullFieldError('QuoteUIState', 'tabIndex');
    }
  }

  @override
  QuoteUIState rebuild(void Function(QuoteUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuoteUIStateBuilder toBuilder() => new QuoteUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuoteUIState &&
        editing == other.editing &&
        editingItemIndex == other.editingItemIndex &&
        historyActivityId == other.historyActivityId &&
        listUIState == other.listUIState &&
        selectedId == other.selectedId &&
        tabIndex == other.tabIndex &&
        saveCompleter == other.saveCompleter &&
        cancelCompleter == other.cancelCompleter;
  }

  int __hashCode;
  @override
  int get hashCode {
    return __hashCode ??= $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc(0, editing.hashCode),
                                editingItemIndex.hashCode),
                            historyActivityId.hashCode),
                        listUIState.hashCode),
                    selectedId.hashCode),
                tabIndex.hashCode),
            saveCompleter.hashCode),
        cancelCompleter.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('QuoteUIState')
          ..add('editing', editing)
          ..add('editingItemIndex', editingItemIndex)
          ..add('historyActivityId', historyActivityId)
          ..add('listUIState', listUIState)
          ..add('selectedId', selectedId)
          ..add('tabIndex', tabIndex)
          ..add('saveCompleter', saveCompleter)
          ..add('cancelCompleter', cancelCompleter))
        .toString();
  }
}

class QuoteUIStateBuilder
    implements Builder<QuoteUIState, QuoteUIStateBuilder> {
  _$QuoteUIState _$v;

  InvoiceEntityBuilder _editing;
  InvoiceEntityBuilder get editing =>
      _$this._editing ??= new InvoiceEntityBuilder();
  set editing(InvoiceEntityBuilder editing) => _$this._editing = editing;

  int _editingItemIndex;
  int get editingItemIndex => _$this._editingItemIndex;
  set editingItemIndex(int editingItemIndex) =>
      _$this._editingItemIndex = editingItemIndex;

  String _historyActivityId;
  String get historyActivityId => _$this._historyActivityId;
  set historyActivityId(String historyActivityId) =>
      _$this._historyActivityId = historyActivityId;

  ListUIStateBuilder _listUIState;
  ListUIStateBuilder get listUIState =>
      _$this._listUIState ??= new ListUIStateBuilder();
  set listUIState(ListUIStateBuilder listUIState) =>
      _$this._listUIState = listUIState;

  String _selectedId;
  String get selectedId => _$this._selectedId;
  set selectedId(String selectedId) => _$this._selectedId = selectedId;

  int _tabIndex;
  int get tabIndex => _$this._tabIndex;
  set tabIndex(int tabIndex) => _$this._tabIndex = tabIndex;

  Completer<SelectableEntity> _saveCompleter;
  Completer<SelectableEntity> get saveCompleter => _$this._saveCompleter;
  set saveCompleter(Completer<SelectableEntity> saveCompleter) =>
      _$this._saveCompleter = saveCompleter;

  Completer<Null> _cancelCompleter;
  Completer<Null> get cancelCompleter => _$this._cancelCompleter;
  set cancelCompleter(Completer<Null> cancelCompleter) =>
      _$this._cancelCompleter = cancelCompleter;

  QuoteUIStateBuilder();

  QuoteUIStateBuilder get _$this {
    if (_$v != null) {
      _editing = _$v.editing?.toBuilder();
      _editingItemIndex = _$v.editingItemIndex;
      _historyActivityId = _$v.historyActivityId;
      _listUIState = _$v.listUIState?.toBuilder();
      _selectedId = _$v.selectedId;
      _tabIndex = _$v.tabIndex;
      _saveCompleter = _$v.saveCompleter;
      _cancelCompleter = _$v.cancelCompleter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuoteUIState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$QuoteUIState;
  }

  @override
  void update(void Function(QuoteUIStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$QuoteUIState build() {
    _$QuoteUIState _$result;
    try {
      _$result = _$v ??
          new _$QuoteUIState._(
              editing: _editing?.build(),
              editingItemIndex: editingItemIndex,
              historyActivityId: historyActivityId,
              listUIState: listUIState.build(),
              selectedId: selectedId,
              tabIndex: tabIndex,
              saveCompleter: saveCompleter,
              cancelCompleter: cancelCompleter);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'editing';
        _editing?.build();

        _$failedField = 'listUIState';
        listUIState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'QuoteUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
