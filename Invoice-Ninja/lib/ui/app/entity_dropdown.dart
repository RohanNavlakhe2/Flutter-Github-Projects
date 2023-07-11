import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/.env.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/ui/app/app_border.dart';
import 'package:invoiceninja_flutter/ui/app/forms/decorated_form_field.dart';
import 'package:invoiceninja_flutter/ui/app/responsive_padding.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';

class EntityDropdown extends StatefulWidget {
  const EntityDropdown({
    Key key,
    @required this.entityType,
    @required this.labelText,
    @required this.onSelected,
    this.entityMap,
    this.entityList,
    this.allowClearing = true,
    this.autoValidate = false,
    this.validator,
    this.entityId,
    this.onAddPressed,
    this.autofocus = false,
    this.showUseDefault = false,
    this.onFieldSubmitted,
    this.overrideSuggestedAmount,
    this.overrideSuggestedLabel,
  }) : super(key: key);

  final EntityType entityType;
  final List<String> entityList;
  final String labelText;
  final String entityId;
  final bool autofocus;
  final BuiltMap<String, SelectableEntity> entityMap;
  final Function(SelectableEntity) onSelected;
  final Function validator;
  final bool autoValidate;
  final bool allowClearing;
  final Function(String) onFieldSubmitted;
  final Function(Completer<SelectableEntity> completer) onAddPressed;
  final Function(BaseEntity) overrideSuggestedAmount;
  final Function(BaseEntity) overrideSuggestedLabel;
  final bool showUseDefault;

  @override
  _EntityDropdownState createState() => _EntityDropdownState();
}

class _EntityDropdownState extends State<EntityDropdown> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  String _filter = '';
  BuiltMap<String, SelectableEntity> _entityMap;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && isMobile(context)) {
        _showOptions();
      }
    });
  }

  @override
  void didChangeDependencies() {
    final localization = AppLocalization.of(context);
    final state = StoreProvider.of<AppState>(context).state;
    _entityMap = widget.entityMap ?? state.getEntityMap(widget.entityType);

    if (_entityMap == null) {
      print('ERROR: ENTITY MAP IS NULL: ${widget.entityType}');
    } else {
      final entity = _entityMap[widget.entityId];
      if (widget.overrideSuggestedLabel != null) {
        _textController.text = widget.overrideSuggestedLabel(entity);
      } else {
        _textController.text = entity?.listDisplayName ?? (widget.showUseDefault ? localization.useDefault : '');
      }
    }

    super.didChangeDependencies();
  }

/*
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entityId == widget.entityId) {
      return;
    }

    final localization = AppLocalization.of(context);
    final state = StoreProvider.of<AppState>(context).state;
    _entityMap = widget.entityMap ?? state.getEntityMap(widget.entityType);

    if (_entityMap == null) {
      print('ERROR: ENTITY MAP IS NULL: ${widget.entityType}');
    } else {
      final entity = _entityMap[widget.entityId];
      if (widget.overrideSuggestedLabel != null) {
        _textController.text = widget.overrideSuggestedLabel(entity);
      } else {
        _textController.text = entity?.listDisplayName ??
            (widget.showUseDefault ? localization.useDefault : '');
      }
    }
  }
  */

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOptions() {
    showDialog<EntityDropdownDialog>(
        context: context,
        builder: (BuildContext context) {
          return EntityDropdownDialog(
            entityMap: _entityMap,
            entityList: widget.entityList ?? _entityMap.keys.toList(),
            onSelected: (entity, [update = true]) {
              if (entity?.id == widget.entityId) {
                return;
              }

              widget.onSelected(entity);

              final String label = widget.overrideSuggestedLabel != null ? widget.overrideSuggestedLabel(entity) : entity.listDisplayName;

              if (update) {
                _textController.text = label;
              }

              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted(label);
              }
            },
            onAddPressed: widget.onAddPressed != null ? (context, completer) => widget.onAddPressed(completer) : null,
            overrideSuggestedAmount: widget.overrideSuggestedAmount,
            overrideSuggestedLabel: widget.overrideSuggestedLabel,
          );
        });
  }

  bool get hasValue => widget.entityId != null && widget.entityId != '0' && widget.entityId.isNotEmpty;

  bool get showClear => widget.allowClearing && hasValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO remove DEMO_MODE check
    if (isNotMobile(context) && !Config.DEMO_MODE) {
      return Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          RawAutocomplete<SelectableEntity>(
            focusNode: _focusNode,
            textEditingController: _textController,
            optionsBuilder: (TextEditingValue textEditingValue) {
              final options =
                  (widget.entityList ?? widget.entityMap.keys.toList()).map((entityId) => _entityMap[entityId]).where((entity) => entity?.matchesFilter(textEditingValue.text) ?? false).toList();

              if (options.length == 1 && options[0].id == widget.entityId) {
                return <SelectableEntity>[];
              }

              return options;
            },
            displayStringForOption: (entity) => entity.listDisplayName,
            onSelected: (entity) {
              /*
              _textController.text = widget.overrideSuggestedLabel != null
                  ? widget.overrideSuggestedLabel(entity)
                  : entity?.listDisplayName;
                  */

              if (entity?.id == widget.entityId) {
                return;
              }

              widget.onSelected(entity);
            },
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
              return DecoratedFormField(
                validator: widget.validator,
                showClear: showClear,
                label: widget.labelText,
                autofocus: widget.autofocus ?? false,
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
                onChanged: (value) => _filter = value,
              );
            },
            optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<SelectableEntity> onSelected, Iterable<SelectableEntity> options) {
              return Theme(
                data: theme,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: AppBorder(
                      child: Container(
                        color: Theme.of(context).cardColor,
                        width: 350,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Theme.of(context).cardColor,
                              child: _EntityListTile(
                                onTap: (entity) => onSelected(entity),
                                entity: options.elementAt(index),
                                filter: _filter,
                                overrideSuggestedAmount: widget.overrideSuggestedAmount,
                                overrideSuggestedLabel: widget.overrideSuggestedLabel,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          showClear
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _textController.text = '';
                    widget.onSelected(null);
                  },
                )
              : widget.onAddPressed != null
                  ? IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      tooltip: AppLocalization.of(context).createNew,
                      onPressed: () {
                        final Completer<SelectableEntity> completer = Completer<SelectableEntity>();
                        widget.onAddPressed(completer);
                        completer.future.then(
                          (entity) {
                            widget.onSelected(entity);
                          },
                        );
                      },
                    )
                  : SizedBox(),
        ],
      );
    }

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        InkWell(
          //key: ValueKey('__stack_${widget.labelText}__'),
          onTap: () => _showOptions(),
          child: IgnorePointer(
            child: TextFormField(
              focusNode: _focusNode,
              readOnly: true,
              validator: widget.validator,
              autovalidateMode: widget.autoValidate ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
              controller: _textController,
              decoration: InputDecoration(
                labelText: widget.labelText,
                suffixIcon: showClear ? null : const Icon(Icons.search),
              ),
            ),
          ),
        ),
        if (showClear)
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _textController.text = '';
              widget.onSelected(null);
            },
          ),
      ],
    );
  }
}

class EntityDropdownDialog extends StatefulWidget {
  const EntityDropdownDialog({
    @required this.entityMap,
    @required this.entityList,
    @required this.onSelected,
    @required this.overrideSuggestedLabel,
    @required this.overrideSuggestedAmount,
    this.onAddPressed,
  });

  final BuiltMap<String, SelectableEntity> entityMap;
  final List<String> entityList;
  final Function(SelectableEntity, [bool]) onSelected;
  final Function(BuildContext context, Completer completer) onAddPressed;
  final Function(BaseEntity) overrideSuggestedAmount;
  final Function(BaseEntity) overrideSuggestedLabel;

  @override
  _EntityDropdownDialogState createState() => _EntityDropdownDialogState();
}

class _EntityDropdownDialogState extends State<EntityDropdownDialog> {
  String _filter;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    void _selectEntity(SelectableEntity entity) {
      widget.onSelected(entity);
      Navigator.pop(context);
    }

    Widget _headerRow() {
      return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: TextField(
              /*
              onSubmitted: (value) {
                final entityId = widget.entityList.firstWhere((entityId) =>
                    _entityMap[entityId].matchesFilter(_filter));
                final entity = _entityMap[entityId];
                _selectEntity(entity);
              },
               */
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
              },
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: localization.filter,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          widget.onAddPressed != null
              ? IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  tooltip: localization.createNew,
                  onPressed: () {
                    Navigator.pop(context);
                    final Completer<SelectableEntity> completer = Completer<SelectableEntity>();
                    widget.onAddPressed(context, completer);
                    completer.future.then((entity) {
                      widget.onSelected(entity, false);
                    });
                  },
                )
              : Container()
        ],
      );
    }

    Widget _createList() {
      final matches = widget.entityList.where((entityId) => widget.entityMap[entityId]?.matchesFilter(_filter) ?? false).toList();

      return ListView.builder(
        shrinkWrap: true,
        itemCount: matches.length,
        itemBuilder: (BuildContext context, int index) {
          final entityId = matches[index];
          final entity = widget.entityMap[entityId];
          return _EntityListTile(
            entity: entity,
            filter: _filter,
            onTap: (entity) => _selectEntity(entity),
            overrideSuggestedAmount: widget.overrideSuggestedAmount,
            overrideSuggestedLabel: widget.overrideSuggestedLabel,
          );
        },
      );
    }

    return ResponsivePadding(
      child: Material(
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _headerRow(),
            Expanded(child: _createList()),
          ],
        ),
      ),
    );
  }
}

class _EntityListTile extends StatelessWidget {
  const _EntityListTile({
    @required this.entity,
    @required this.filter,
    @required this.overrideSuggestedLabel,
    @required this.overrideSuggestedAmount,
    this.onTap,
  });

  final SelectableEntity entity;
  final Function(SelectableEntity entity) onTap;
  final String filter;
  final Function(BaseEntity) overrideSuggestedAmount;
  final Function(BaseEntity) overrideSuggestedLabel;

  @override
  Widget build(BuildContext context) {
    final String subtitle = entity.matchesFilterValue(filter);
    final String label = overrideSuggestedLabel == null ? entity.listDisplayName : overrideSuggestedLabel(entity);
    final String amount = overrideSuggestedAmount == null ? formatNumber(entity.listDisplayAmount, context, formatNumberType: entity.listDisplayAmountType) : overrideSuggestedAmount(entity);

    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.headline6),
          ),
          entity.listDisplayAmount != null ? Text(amount, style: Theme.of(context).textTheme.headline6) : Container(),
        ],
      ),
      subtitle: subtitle != null ? Text(subtitle, maxLines: 2) : null,
      onTap: onTap != null ? () => onTap(entity) : null,
    );
  }
}
