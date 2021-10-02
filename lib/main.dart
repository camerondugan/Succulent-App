import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:succ/shop.dart';
import 'package:succ/storage.dart';
import 'package:succ/plant_card.dart';
import 'package:window_size/window_size.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  setWindowSize();
  runApp(const MyApp());
}

void setWindowSize() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    const scale = 55.0;
    const width = 9.0;
    const height = 19.0;
    setWindowTitle('Succ');
    setWindowMinSize(const Size(width * scale, height * scale));
    setWindowMaxSize(const Size(width * scale, height * scale));
  }
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
  var plantWater = [3, 3, 3, 3];
  var plantWaterExpressions = [
    "I'm dehydrated",
    "I'm satisfied",
    "I'm drowning",
    "Empty",
  ];
  var shopPlants = [
    "assets/Plant1Dead.png",
    "assets/Plant1Full.png",
    "assets/Plant1Medium.png",
    "assets/Plant1Sprout.png",
    "assets/Plant1Full.png",
    "assets/Plant1Full.png",
  ];
  var colors = [
    0xffCB997E,
    0xffDDBEA9,
    0xffFFE8D6,
    0xffB7B7A4,
    0xffA5A58D,
    0xff6B705C
  ];
  int pageIndex = 0;
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
      if (savedPlants.isNotEmpty) {
        plants = savedPlants;
      }
      if (savedWater.isNotEmpty) {
        plantWater = savedWater;
      }
      setState(() {});
    });
  }

  void takeFromShop(index) {
    int i = 0;
    for (String s in plants) {
      if (s == "assets/NoPlant.png") {
        plants[i] = shopPlants[index];
        shopPlants[index] = "assets/NoPlant.png";
        plantWater[i] = 0;
        setState(() {});
        save.writePlants(plants);
        save.writeWater(plantWater);
        return;
      }
      i++;
    }
    const snackBar = SnackBar(
      content: Text('Your home is full 😭'),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      duration: Duration(milliseconds: 1300),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  int takeFromHome(index) {
    int i = 0;
    for (String plant in shopPlants) {
      if (plant == 'assets/NoPlant.png') {
        shopPlants[i] = plants[index];
        plants[index] = 'assets/NoPlant.png';
        plantWater[index] = 3;
        setState(() {});
        save.writePlants(plants);
        save.writeWater(plantWater);
        return i;
      }
      plants[index] = 'assets/NoPlant.png';
      plantWater[index] = 3;
      setState(() {});
      save.writePlants(plants);
      save.writeWater(plantWater);
      i++;
    }
    return -1;
  }

  Widget shop() {
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
                )
                //plantCard(tags[index], cardHeight, tagHeight,
                //shopPlants[index], 30, true),
                ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cardHeight = MediaQuery.of(context).size.width * 8 / 8;
    var tagHeight = 2;
    var _pages = <Widget>[
      Swiper(
        itemCount: plants.length,
        layout: SwiperLayout.STACK,
        itemWidth: MediaQuery.of(context).size.width * 7 / 8,
        itemHeight: cardHeight + tagHeight,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (plants[index] != "assets/NoPlant.png") {
                plantWater[index] = min(plantWater[index] + 1, 2);
              }
              save.writeWater(plantWater);
              setState(() {});
            },
            onLongPress: () {
              int hydration = plantWater[index];
              int shopItemIndex = takeFromHome(index);
              final snack = SnackBar(
                content: const Text("You sold your plant! :)"),
                shape: const RoundedRectangleBorder(),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    if (shopItemIndex != -1) {
                      takeFromShop(shopItemIndex);
                      plantWater[index] = hydration;
                      save.writeWater(plantWater);
                    }
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
            child: PlantCard(
              tag: plantWaterExpressions[plantWater[index % plantWater.length]],
              height: cardHeight,
              tagHeight: tagHeight,
              plant: plants[index],
              edgeRadius: 50,
            ),
          );
        },
      ),
      Shop(
          shopPlants: shopPlants,
          takeFromShop: (int i) {
            takeFromShop(i);
          }),
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
