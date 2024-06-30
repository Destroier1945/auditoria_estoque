
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



Future<void> importDataFromFile()async{
  await Permission.storage.request();

  Directory? directory = await getApplicationDocumentsDirectory();
  final pathToFile = path.join(directory.path, 'cadastro.txt');

  List<String> lines = await File(pathToFile).readAsLines();

  Database database = await openDatabase(
    path.join(directory.path, 'products.db'),
    version: 1,
    onCreate:
    (db,version){
      return db.execute(
          'CREATE TABLE products (id INTEGER PRIMARY KEY, ean TEXT, description TEXT, complement TEXT, brand TEXT)',
      );
    }
  );

  await database.transaction((txn) async {
    for(String line in lines ){
      List<String> fields = line.split(';');
      if(fields.length >= 4 ){
        String ean = fields[0].trim();
        String description = fields[1].trim();
        String complement = fields[2].trim();
        String brand = fields[3].trim();
      }
    }
  });
  await database.close();

 // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dados importados com sucesso'),));
}

