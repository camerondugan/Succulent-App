import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:succ/shop.dart';
import 'package:succ/storage.dart';
import 'package:succ/plant_card.dart';
import 'package:window_size/window_size.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'first_day_done_dialogue.dart';

void main() {
  //setWindowSize();
  runApp(const MyApp());
}

void setWindowSize() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    const scale = 55.0;
    const width = 9.0;
    const height = 19.0;
    setWindowTitle('Succulents');
    setWindowMinSize(const Size(width * scale, height * scale));
    setWindowMaxSize(const Size(width * scale, height * scale));
  }
}

String changePlantSize(String plant, String size) {
  return plant.substring(0, 15) + size + plant.substring(plant.length - 4);
}

String getPlantSize(String plant) {
  return plant.substring(15, plant.length - 4);
}

String changePlantType(String plant, int type) {
  return plant.substring(0, 12) +
      type.toString().padLeft(3, '0') +
      plant.substring(15);
}

String growPlant(String plant) {
  if (plant.length <= 18) {
    return plant;
  }
  String curSize = getPlantSize(plant);
  if (curSize == "Sprout") {
    plant = changePlantSize(plant, "Medium");
  } else if (curSize == "Medium") {
    plant = changePlantSize(plant, "Full");
  }
  return plant;
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Succulents',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), // standard dark theme
      themeMode: ThemeMode.system, // device controls theme
      scrollBehavior: AppScrollBehavior(),
      home: const Succ(title: 'Succulents'),
    );
  }
}

class Succ extends StatefulWidget {
  const Succ({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Succ> createState() => _SuccState();
}

class _SuccState extends State<Succ> {
  var plants = [
    "assets/NoPlant.png",
  ];
  var plantWater = [4];
  var plantWaterExpressions = [
    "I'm dehydrated",
    "I'm satisfied",
    "I'm drowning",
    "I'm dead",
    "Empty",
  ];
  var numShopPlants = 1;
  var shopPlants = List<String>.empty();
  var colors = [
    0xffCB997E,
    0xffDDBEA9,
    0xffFFE8D6,
    0xffB7B7A4,
    0xffA5A58D,
    0xff6B705C
  ];
  DateTime now = DateTime.now();
  DateTime lastTick = DateTime.now();
  int pageIndex = 0;
  int pindex = 0;
  final int difTypesOfPlants = 4;
  List<int> purchasedPlants = [];
  Storage save = Storage();

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future.delayed(Duration.zero, () async {
      var savedPlants = await save.readYourPlants();
      var savedWater = await save.readWater();
      var savedPurchases = await save.readPurchases();
      numShopPlants = await save.readShop();
      var lt = await save.readLastTick();
      if (lt != null) {
        lastTick = lt;
      }
      if (savedPlants.isNotEmpty) {
        plants = savedPlants;
      }
      if (savedWater.isNotEmpty) {
        plantWater = savedWater;
      }
      if (savedPurchases.isNotEmpty) {
        purchasedPlants = savedPurchases.cast<int>();
      }
      if (lt == null) {
        lt = now;
        save.writeLastTick(now);
      }
      if (now.difference(lt) > const Duration(hours: 0)) {
        onTick();
        save.writeLastTick(now);
      }
      genShopPlants();
      setState(() {});
    });
  }

  void onTick() {
    bool perfectDay = true;
    //Kill over and under wattered plants and grow the others
    for (int i = 0; i < plants.length; i++) {
      if (plants[i] != "assets/NoPlant.png" &&
          (plantWater[i] == 0 || plantWater[i] == 2)) {
        plants[i] = "assets/DeadPlant.png";
        perfectDay = false;
        plantWater[i] = 4;
      }
      if (plants[i].contains('Dead')) {
        plantWater[i] = 3;
      } else if (!plants[i].contains("NoPlant")) {
        plantWater[i] -= 1;
        if (plantWater[i] == -1) {
          plantWater[i] = 3;
        }
      }
      plants[i] = growPlant(plants[i]);
    }
    if (perfectDay) {
      //increase plant slots and shop slots
      plants.add('assets/NoPlant.png');
      plantWater.add(4);
    }
    numShopPlants = max((plants.length / 2).round(), 1);
    purchasedPlants = [];
    save.writePlants(plants);
    save.writeWater(plantWater);
    save.writePurchases(purchasedPlants);
    save.writeShop(numShopPlants);
  }

  void takeFromShop(index) {
    int i = 0;
    for (String s in plants) {
      if (s == "assets/NoPlant.png") {
        plants[i] = shopPlants[index];
        purchasedPlants.add(index);
        plantWater[i] = 0;
        setState(() {});
        save.writePlants(plants);
        save.writeWater(plantWater);
        save.writePurchases(purchasedPlants);
        return;
      }
      i++;
    }
    const snackBar = SnackBar(
      content: Text('Your home is full 😭'),
      backgroundColor: Colors.greenAccent,
      elevation: 1.0,
      padding: EdgeInsets.all(10),
      duration: Duration(milliseconds: 1300),
      dismissDirection: DismissDirection.horizontal,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void genShopPlants() {
    Random r = Random(lastTick.toString().substring(0, 10).hashCode);
    shopPlants = List<String>.empty(growable: true);
    var i = numShopPlants;
    while (i > 0) {
      shopPlants.add(changePlantType(
          "assets/Plant000Sprout.png", r.nextInt(difTypesOfPlants) + 1));
      i--;
    }
  }

  int takeFromHome(index) {
    if (plants[index].contains("Dead")) {
      plantWater.removeAt(index);
      plants.removeAt(index);
      setState(() {});
      save.writePlants(plants);
      save.writeWater(plantWater);
      return -1;
    }
    for (int i = 0; i < shopPlants.length; i++) {
      if (purchasedPlants.contains(i) && plantWater[index] < 2) {
        purchasedPlants.remove(i);
        shopPlants[i] = plants[index];
        plants[index] = 'assets/NoPlant.png';
        plantWater[index] = 4;
        setState(() {});
        save.writePlants(plants);
        save.writeWater(plantWater);
        save.writePurchases(purchasedPlants);
        return i;
      }
    }
    plants[index] = 'assets/NoPlant.png';
    plantWater[index] = 4;
    setState(() {});
    save.writePlants(plants);
    save.writeWater(plantWater);
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    var cardHeight = MediaQuery.of(context).size.height;
    var cardWidth = MediaQuery.of(context).size.width;
    var tagHeight = 2;
    var _pages = <Widget>[
      Center(
        // Plant Cards
        child: SizedBox(
          height: min(cardHeight, cardWidth),
          child: PageView.builder(
            itemCount: plants.length,
            controller: PageController(
              viewportFraction: cardWidth - 50 > cardHeight ? .5 : .9,
            ),
            onPageChanged: (int i) => setState(() => pindex = i),
            physics: const BouncingScrollPhysics(),
            pageSnapping: true,
            itemBuilder: (_, i) {
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: .7, end: i == pindex ? .9 : .7),
                duration: const Duration(milliseconds: 200),
                builder: (_, double scale, __) {
                  return Transform.scale(
                    scale: scale,
                    child: GestureDetector(
                      onTap: () {
                        if (plants[i] == "assets/DeadPlant.png") {
                        } else if (plants[i] != "assets/NoPlant.png") {
                          plantWater[i] = min(plantWater[i] + 1, 2);
                        }
                        if (plants.length == 1 && plantWater[i] == 1) {
                          dialogue(context);
                        }
                        save.writeWater(plantWater);
                        setState(() {});
                      },
                      onLongPress: () {
                        if (plants[i].contains('NoPlant')) {
                          return;
                        }
                        int hydration = plantWater[i];
                        final String plant = plants[i];
                        int shopItemIndex = takeFromHome(i);
                        SnackBar snack = SnackBar(
                          content: plant.contains("Dead")
                              ? const Text(
                                  "You threw out your plant. :(",
                                  style: TextStyle(color: Colors.black),
                                )
                              : const Text(
                                  "You sold your plant! :)",
                                  style: TextStyle(color: Colors.black),
                                ),
                          shape: const RoundedRectangleBorder(),
                          dismissDirection: DismissDirection.horizontal,
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.greenAccent,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      },
                      child: PlantCard(
                        tag: plantWaterExpressions[
                            plantWater[i % plantWater.length]],
                        height: cardHeight,
                        tagHeight: tagHeight,
                        plant: plants[i],
                        index: i,
                        edgeRadius: 50,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      Shop(
        shopPlants: shopPlants,
        takeFromShop: (int i) {
          takeFromShop(i);
        },
        takenPlants: purchasedPlants,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueGrey,
        index: pageIndex,
        color: Colors.black,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.house_rounded, size: 30, color: Colors.white),
          Icon(Icons.storefront_rounded, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() => pageIndex = index);
        },
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        primary: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.blueGrey,
      body: IndexedStack(
        index: pageIndex,
        children: _pages,
      ),
    );
  }
}
