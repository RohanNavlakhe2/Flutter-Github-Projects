import 'package:flutter/material.dart';

import 'package:flutter_design_patterns/constants.dart';
import 'package:flutter_design_patterns/design_patterns/builder/burger.dart';
import 'package:flutter_design_patterns/design_patterns/builder/burger_builders/index.dart';
import 'package:flutter_design_patterns/design_patterns/builder/burger_maker.dart';
import 'package:flutter_design_patterns/widgets/design_patterns/builder/burger_information/burger_information_column.dart';
import 'package:flutter_design_patterns/widgets/design_patterns/builder/burger_menu_item.dart';

class BuilderExample extends StatefulWidget {
  @override
  _BuilderExampleState createState() => _BuilderExampleState();
}

class _BuilderExampleState extends State<BuilderExample> {
  final BurgerMaker _burgerMaker = BurgerMaker(HamburgerBuilder());
  final List<BurgerMenuItem> _burgerMenuItems = [];

  BurgerMenuItem _selectedBurgerMenuItem;
  Burger _selectedBurger;

  @override
  void initState() {
    super.initState();

    _burgerMenuItems.addAll([
      BurgerMenuItem(
        label: 'Hamburger',
        burgerBuilder: HamburgerBuilder(),
      ),
      BurgerMenuItem(
        label: 'Cheeseburger',
        burgerBuilder: CheeseburgerBuilder(),
      ),
      BurgerMenuItem(
        label: 'Big Mac\u00AE',
        burgerBuilder: BigMacBuilder(),
      ),
      BurgerMenuItem(
        label: 'McChicken\u00AE',
        burgerBuilder: McChickenBuilder(),
      )
    ]);

    _selectedBurgerMenuItem = _burgerMenuItems[0];
    _selectedBurger = _prepareSelectedBurger();
  }

  Burger _prepareSelectedBurger() {
    _burgerMaker.prepareBurger();

    return _burgerMaker.getBurger();
  }

  void _onBurgerMenuItemChanged(BurgerMenuItem selectedItem) {
    setState(() {
      _selectedBurgerMenuItem = selectedItem;
      _burgerMaker.changeBurgerBuilder(selectedItem.burgerBuilder);
      _selectedBurger = _prepareSelectedBurger();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Select menu item:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            DropdownButton(
              value: _selectedBurgerMenuItem,
              items: _burgerMenuItems
                  .map<DropdownMenuItem<BurgerMenuItem>>(
                    (BurgerMenuItem item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: _onBurgerMenuItemChanged,
            ),
            SizedBox(height: spaceL),
            Row(
              children: <Widget>[
                Text(
                  'Information:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(height: spaceM),
            BurgerInformationColumn(burger: _selectedBurger),
          ],
        ),
      ),
    );
  }
}
