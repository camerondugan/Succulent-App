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
    "assets/NoPlant.png",
    "assets/NoPlant.png",
    "assets/NoPlant.png",
  ];
  var plantWater = [4, 4, 4, 4];
  var plantWaterExpressions = [
    "I'm dehydrated",
    "I'm satisfied",
    "I'm drowning",
    "I'm dead",
    "Empty",
  ];
  var shopPlants = [
    "assets/Plant003Sprout.png",
    "assets/Plant001Sprout.png",
    "assets/Plant002Sprout.png",
    "assets/Plant004Sprout.png",
    "assets/Plant002Sprout.png",
    "assets/Plant001Sprout.png",
  ];
  var colors = [
    0xffCB997E,
    0xffDDBEA9,
    0xffFFE8D6,
    0xffB7B7A4,
    0xffA5A58D,
    0xff6B705C
  ];
  DateTime now = DateTime.now();
  int pageIndex = 0;
  int pindex = 0;
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
      var lastTick = await save.readLastTick();
      if (savedPlants.isNotEmpty) {
        plants = savedPlants;
      }
      if (savedWater.isNotEmpty) {
        plantWater = savedWater;
      }
      if (savedPurchases.isNotEmpty) {
        purchasedPlants = savedPurchases.cast<int>();
      }
      if (lastTick == null) {
        lastTick = now;
        save.writeLastTick(now);
      }
      if (now.difference(lastTick) > const Duration(hours: 16)) {
        onTick();
        save.writeLastTick(now);
      }
      setState(() {});
    });
  }

  void onTick() {
    for (int i = 0; i < plantWater.length; i++) {
      if (plants[i] != "assets/NoPlant.png" &&
          (plantWater[i] == 0 || plantWater[i] == 2)) {
        plants[i] = "assets/DeadPlant.png";
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
    purchasedPlants = [];
    save.writePlants(plants);
    save.writeWater(plantWater);
    save.writePurchases(purchasedPlants);
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

  int takeFromHome(index) {
    int i = 0;
    if (plants[index].contains("Dead")) {
      plants[index] = 'assets/NoPlant.png';
      plantWater[index] = 4;
      setState(() {});
      save.writePlants(plants);
      save.writeWater(plantWater);
    }
    for (String plant in shopPlants) {
      if (plant == plants[index] && purchasedPlants.contains(i)) {
        purchasedPlants.remove(i);
        plants[index] = 'assets/NoPlant.png';
        plantWater[index] = 4;
        setState(() {});
        save.writePlants(plants);
        save.writeWater(plantWater);
        save.writePurchases(purchasedPlants);
        return i;
      }
      i++;
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
    print(cardWidth / cardHeight);
    var tagHeight = 2;
    var _pages = <Widget>[
      Center(
        // Plant Cards
        child: SizedBox(
          height: min(cardHeight, cardWidth),
          child: PageView.builder(
            itemCount: plants.length,
            controller: PageController(
              viewportFraction: .8,
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
                        if (plants[i] != "assets/NoPlant.png") {
                          plantWater[i] = min(plantWater[i] + 1, 2);
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
                              ? const Text("You threw out your plant. :(")
                              : const Text("You sold your plant! :)"),
                          shape: const RoundedRectangleBorder(),
                          dismissDirection: DismissDirection.horizontal,
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.greenAccent,
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              if (shopItemIndex != -1) {
                                takeFromShop(shopItemIndex);
                                plantWater[i] = hydration;
                                save.writeWater(plantWater);
                              }
                            },
                          ),
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

    //Swiper(
    //itemCount: plants.length,
    //layout: SwiperLayout.STACK,
    //itemWidth: MediaQuery.of(context).size.width * 7 / 8,
    //itemHeight: cardHeight + tagHeight,
    //itemBuilder: (BuildContext context, int index) {
    //return GestureDetector(
    //onTap: () {
    //if (plants[index] != "assets/NoPlant.png") {
    //plantWater[index] = min(plantWater[index] + 1, 3);
    //}
    //save.writeWater(plantWater);
    //setState(() {});
    //},
    //onLongPress: () {
    //if (plants[index].contains('NoPlant')) {
    //return;
    //}
    //int hydration = plantWater[index];
    //final String plant = plants[index];
    //int shopItemIndex = takeFromHome(index);
    //SnackBar snack = SnackBar(
    //content: plant.contains("Dead")
    //? const Text("You threw out your plant. :(")
    //: const Text("You sold your plant! :)"),
    //shape: const RoundedRectangleBorder(),
    //dismissDirection: DismissDirection.horizontal,
    //duration: const Duration(seconds: 1),
    //backgroundColor: Colors.greenAccent,
    //action: SnackBarAction(
    //label: 'Undo',
    //onPressed: () {
    //if (shopItemIndex != -1) {
    //takeFromShop(shopItemIndex);
    //plantWater[index] = hydration;
    //save.writeWater(plantWater);
    //}
    //},
    //),
    //);
    //ScaffoldMessenger.of(context).showSnackBar(snack);
    //},
    //child: PlantCard(
    //tag: plantWaterExpressions[plantWater[index % plantWater.length]],
    //height: cardHeight,
    //tagHeight: tagHeight,
    //plant: plants[index],
    //index: index,
    //edgeRadius: 50,
    //),
    //);
    //},
    //),

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
