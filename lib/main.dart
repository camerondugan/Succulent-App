import 'dart:io';
import 'package:succ/plant_card.dart';
import 'package:succ/shop.dart';
import 'package:flutter/material.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Succulents',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), // standard dark theme
      themeMode: ThemeMode.system, // device controls theme
      home: const MyHomePage(title: 'Succulents'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var plants = [
    "assets/Plant #1 Dead.png",
    "assets/Plant #1 Sprout.png",
    "assets/Plant #1 Medium.png",
    "assets/Plant #1 Full.png",
  ];
  var colors = [
    0xffCB997E,
    0xffDDBEA9,
    0xffFFE8D6,
    0xffB7B7A4,
    0xffA5A58D,
    0xff6B705C
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    var cardHeight = MediaQuery.of(context).size.width * 7 / 8;
    var tagHeight = 100;
    var _pages = <Widget>[
      Swiper(
        itemCount: 4,
        layout: SwiperLayout.STACK,
        itemWidth: MediaQuery.of(context).size.width * 7 / 8,
        itemHeight: cardHeight + tagHeight,
        itemBuilder: (BuildContext context, int index) {
          return PlantCardGen(
              cardHeight: cardHeight,
              tagHeight: tagHeight,
              plants: plants,
              index: index);
        },
      ),
      const ShopPage(),
    ];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueGrey,
        index: _index,
        color: Colors.black,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: const Duration(milliseconds: 1000),
        items: const <Widget>[
          Icon(Icons.list_alt, size: 30),
          Icon(Icons.store_outlined, size: 30),
        ],
        onTap: (index) {
          setState(() => _index = index);
          stderr.writeln(_index);
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
        index: _index,
        children: _pages,
      ),
    );
  }
}
