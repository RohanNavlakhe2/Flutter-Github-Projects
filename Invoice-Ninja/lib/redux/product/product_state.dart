import 'dart:async';

import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja_flutter/redux/ui/entity_ui_state.dart';
import 'package:invoiceninja_flutter/redux/ui/list_ui_state.dart';

part 'product_state.g.dart';

abstract class ProductState
    implements Built<ProductState, ProductStateBuilder> {
  factory ProductState() {
    return _$ProductState._(
      map: BuiltMap<String, ProductEntity>(),
      list: BuiltList<String>(),
    );
  }
  ProductState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, ProductEntity> get map;
  BuiltList<String> get list;

  ProductState loadProducts(BuiltList<ProductEntity> clients) {
    final map = Map<String, ProductEntity>.fromIterable(
      clients,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace((map.keys.toList() + list.toList()).toSet().toList()));
  }

  static Serializer<ProductState> get serializer => _$productStateSerializer;
}

abstract class ProductUIState extends Object
    with EntityUIState
    implements Built<ProductUIState, ProductUIStateBuilder> {
  factory ProductUIState() {
    return _$ProductUIState._(
      listUIState: ListUIState(ProductFields.productKey),
      editing: ProductEntity(),
      selectedId: '',
      tabIndex: 0,
    );
  }
  ProductUIState._();

  @override
  @memoized
  int get hashCode;

  @nullable
  ProductEntity get editing;

  @override
  bool get isCreatingNew => editing.isNew;

  @override
  String get editingId => editing.id;

  static Serializer<ProductUIState> get serializer =>
      _$productUIStateSerializer;
}
