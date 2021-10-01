import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String tag;
  final String plant;
  final int tagHeight;
  final double height;
  final double edgeRadius;


  const PlantCard({
    Key? key,
    required this.tag,
    required this.height,
    required this.tagHeight,
    required this.plant,
    required this.edgeRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(edgeRadius),
          topRight: Radius.circular(edgeRadius),
          bottomLeft: Radius.circular(edgeRadius),
          bottomRight: Radius.circular(edgeRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.75),
            offset: const Offset(4, 8),
          ),
        ],
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(edgeRadius),
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
                    height: height,
                    width: height,
                    fit: BoxFit.fill,
                  ),
                  Image.asset(
                    plant,
                    height: height,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: tagHeight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    tag,
                    style: const TextStyle(
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