import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  final String hiddenFolder = '.succulents';
  final String delim = '\n';

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  String generateString(List<Object> l) {
    var buffer = StringBuffer();

    int count = 0;
    for (Object o in l) {
      buffer.write(o.toString());
      if (count < l.length - 1) {
        buffer.write(delim);
      }
      count++;
    }
    return buffer.toString();
  }

  Future<File> get _yourPlantsFile async {
    final dir = await Directory('${await localPath}/$hiddenFolder')
        .create(recursive: true);
    final path = dir.path;
    return File('$path/plants.txt');
  }

  Future<File> get _shop async {
    final dir = await Directory('${await localPath}/$hiddenFolder')
        .create(recursive: true);
    final path = dir.path;
    return File('$path/shop.txt');
  }

  Future<File> get _plantVariety async {
    final dir = await Directory('${await localPath}/$hiddenFolder')
        .create(recursive: true);
    final path = dir.path;
    return File('$path/variety.txt');
  }

  Future<File> get _yourWater async {
    final dir = await Directory('${await localPath}/$hiddenFolder')
        .create(recursive: true);
    final path = dir.path;
    return File('$path/water.txt');
  }

  Future<File> get _purchases async {
    final dir = await Directory('${await localPath}/$hiddenFolder')
        .create(recursive: true);
    final path = dir.path;
    return File('$path/purchases.txt');
  }

  Future<File> get _lastTick async {
    final dir = await Directory('${await localPath}/$hiddenFolder')
        .create(recursive: true);
    final path = dir.path;
    return File('$path/lastTick.txt');
  }

  Future<File> writeShop(int shop) async {
    final file = await _shop;

    // Write the file
    return file.writeAsString(shop.toString());
  }

  Future<int> readShop() async {
    try {
      final file = await _shop;

      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 1;
    }
  }

  Future<File> writeVariety(int variety) async {
    final file = await _plantVariety;

    // Write the file
    return file.writeAsString(variety.toString());
  }

  Future<int> readVariety() async {
    try {
      final file = await _plantVariety;

      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 1;
    }
  }

  Future<File> writeWater(List<int> water) async {
    final file = await _yourWater;

    // Write the file
    return file.writeAsString(generateString(water));
  }

  Future<List<int>> readWater() async {
    try {
      final file = await _yourWater;

      final contents = await file.readAsString();
      List<String> tmp = contents.split(delim);
      List<int> ans = [];
      for (String s in tmp) {
        ans.add(int.parse(s));
      }
      return ans;
    } catch (e) {
      return [];
    }
  }

  Future<File> writePurchases(List<int> plants) async {
    final file = await _purchases;

    // Write the file
    return file.writeAsString(generateString(plants));
  }

  Future<List<int>> readPurchases() async {
    try {
      final file = await _purchases;

      final contents = await file.readAsString();
      List<int> ans = [];
      for (String s in contents.split(delim)) {
        ans.add(int.parse(s));
      }

      return ans;
    } catch (e) {
      return [];
    }
  }

  Future<File> writePlants(List<String> plants) async {
    final file = await _yourPlantsFile;

    // Write the file
    return file.writeAsString(generateString(plants));
  }

  Future<List<String>> readYourPlants() async {
    try {
      final file = await _yourPlantsFile;

      final contents = await file.readAsString();

      return contents.split(delim);
    } catch (e) {
      return [];
    }
  }

  Future<File> writeLastTick(DateTime tick) async {
    final file = await _lastTick;

    // Write the file
    return file.writeAsString(tick.toString());
  }

  Future<dynamic> readLastTick() async {
    dynamic contents;
    try {
      final file = await _lastTick;

      contents = await file.readAsString();

      return DateTime.parse(contents);
    } catch (e) {
      return null;
    }
  }
}
