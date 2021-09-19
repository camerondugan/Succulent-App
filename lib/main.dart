import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:card_swiper/card_swiper.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    const scale = 55.0;
    const width = 9.0;
    const height = 19.0;
    setWindowTitle('Succ');
    setWindowMinSize(const Size(width * scale, height * scale));
    setWindowMaxSize(const Size(width * scale, height * scale));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Swiper(
          itemCount: 2,
          layout: SwiperLayout.STACK,
          itemWidth: 300.0,
          itemHeight: 400.0,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
                overflow: Overflow.visible,
                clipBehavior: Clip.hardEdge,
                children: [
                  Image.asset(
                    "assets/plantbg.jpg",
                    fit: BoxFit.fill,
                  ),
                  Image.asset(
                    "assets/Plant #1 Dead.png",
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
