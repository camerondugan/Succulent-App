import 'package:flutter/material.dart';
import 'package:succ/plant_card.dart';

class Shop extends StatelessWidget {
  final List<String> shopPlants;
  final Function takeFromShop;

  const Shop({
    Key? key,
    required this.shopPlants,
    required this.takeFromShop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cardHeight = MediaQuery.of(context).size.height;
    var tagHeight = 2;
    var tags = [];
    for (String plant in shopPlants) {
      if (plant == "assets/NoPlant.png") {
        tags.add("Sold!");
      } else {
        tags.add("Buy Me!");
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
      child: GridView.builder(
        itemCount: shopPlants.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                takeFromShop(index);
              },
              child: PlantCard(
                plant: shopPlants[index],
                tag: tags[index],
                height: cardHeight,
                tagHeight: tagHeight,
                edgeRadius: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}
