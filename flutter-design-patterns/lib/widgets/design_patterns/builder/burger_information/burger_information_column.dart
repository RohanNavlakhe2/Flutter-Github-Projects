import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_design_patterns/constants.dart';
import 'package:flutter_design_patterns/design_patterns/builder/burger.dart';
import 'package:flutter_design_patterns/widgets/design_patterns/builder/burger_information/burger_information_label.dart';

class BurgerInformationColumn extends StatelessWidget {
  final Burger burger;

  const BurgerInformationColumn({
    @required this.burger,
  }) : assert(burger != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BurgerInformationLabel('Price'),
        Text(burger.getFormattedPrice()),
        SizedBox(height: spaceM),
        BurgerInformationLabel('Ingredients'),
        Text(
          burger.getFormattedIngredients(),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: spaceM),
        BurgerInformationLabel('Allergens'),
        Text(
          burger.getFormattedAllergens(),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
