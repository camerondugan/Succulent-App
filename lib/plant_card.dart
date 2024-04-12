import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  Image.asset(
                    plant,
                    height: height,
                    fit: BoxFit.cover,
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
                      child: AutoSizeText(
                        tag,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: Row(
                          children: [
                            const Spacer(),
                            const Spacer(),
                            AutoSizeText(
                              tag,
                              presetFontSizes: const [
                                40,
                                35,
                                30,
                                25,
                                20,
                                15,
                                10
                              ],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            const Spacer(),
                            AutoSizeText(
                              "#${index + 1}",
                              presetFontSizes: const [
                                40,
                                35,
                                30,
                                25,
                                20,
                                15,
                                10
                              ],
                              style: const TextStyle(
                                color: Colors.black,
                                backgroundColor: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
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
