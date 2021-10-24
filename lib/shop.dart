import 'package:flutter/material.dart';
import 'package:succ/plant_card.dart';

class Shop extends StatelessWidget {
  final List<String> shopPlants;
  final Function takeFromShop;
  final List<int> takenPlants;

  const Shop({
    Key? key,
    required this.shopPlants,
    required this.takeFromShop,
    required this.takenPlants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cardHeight = MediaQuery.of(context).size.height;
    var tagHeight = 2;
    var tags = [];
    for (int i = 0; i < shopPlants.length; i++) {
      if (takenPlants.contains(i)) {
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
                if (!takenPlants.contains(index)) {
                  takeFromShop(index);
                }
              },
              child: PlantCard(
                plant: takenPlants.contains(index)
                    ? "assets/NoPlant.png"
                    : shopPlants[index],
                tag: tags[index],
                height: cardHeight,
                tagHeight: tagHeight,
                index: index,
                edgeRadius: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}
