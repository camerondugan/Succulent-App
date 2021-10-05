import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String plant;
  final String tag;
  final int tagHeight;
  final double height;
  final int index;
  final double edgeRadius;

  const PlantCard({
    Key? key,
    required this.plant,
    required this.tag,
    required this.tagHeight,
    required this.height,
    required this.index,
    required this.edgeRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int showNum = 1;
    if (tag == "Buy Me!" || tag == "Sold!") {
      showNum = 0;
    }
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
                child: IndexedStack(
                  index: showNum,
                  children: [
                    Center(
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        children: [
                          const Spacer(),
                          const Spacer(),
                          const Spacer(),
                          const Spacer(),
                          Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "#" + (index + 1).toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              backgroundColor: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
