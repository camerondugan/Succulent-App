import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  final String hiddenFolder = '.succulents';
  final String delim = ',';

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
    final dir = await Directory(await localPath + '/' + hiddenFolder)
        .create(recursive: true);
    final path = dir.path;
    return File('$path/yourPlants.txt');
  }

  Future<File> get _yourWater async {
    final dir = await Directory(await localPath + '/' + hiddenFolder)
        .create(recursive: true);
    final path = dir.path;
    return File('$path/yourWater.txt');
  }

  Future<File> get _purchasedPlants async {
    final dir = await Directory(await localPath + '/' + hiddenFolder)
        .create(recursive: true);
    final path = dir.path;
    return File('$path/shopPlants.txt');
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
      // ignore: avoid_print
      return ans;
    } catch (e) {
      return [];
    }
  }

  Future<File> writeShopPlants(List<String> plants) async {
    final file = await _purchasedPlants;

    // Write the file
    return file.writeAsString(generateString(plants));
  }

  Future<List<String>> readShopPlants() async {
    try {
      final file = await _purchasedPlants;

      final contents = await file.readAsString();

      return contents.split(delim);
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
}
