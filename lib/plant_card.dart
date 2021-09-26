import 'package:flutter/material.dart';

class PlantCardGen extends StatelessWidget {
  const PlantCardGen({
    Key? key,
    required this.cardHeight,
    required this.tagHeight,
    required this.plants,
    required this.index,
  }) : super(key: key);

  final double cardHeight;
  final int tagHeight;
  final List<String> plants;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.75),
            offset: const Offset(8, 8),
          ),
        ],
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/plantbg.jpg",
                    height: cardHeight + 4 * tagHeight,
                    width: cardHeight + 2 * tagHeight,
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    plants[index],
                    height: cardHeight,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    "I am plant!",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
