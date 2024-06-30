import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
   SettingsPage({super.key});


  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final Map<String, int> _stockData = {};

  Future<void> _requestPermission()async{
    await Permission.storage.request();
  }

  Future<void> _exportData() async {

    await _requestPermission();
    Directory? directory = Directory('/storage/emulated/0/Documents');
    if(!(await directory.exists())) {
      directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      directory = Directory('$path/Documents');
    }

    final path = '${directory.path}/estoque.txt';
    final file = File(path);

    StringBuffer buffer = StringBuffer();
    _stockData.forEach((barcode, quantity) {
      buffer.writeln('$barcode;$quantity;');
    });

    await file.writeAsString(buffer.toString());


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dados exportados para $path')));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){},
                  child: Text('Importar cadastro'),
                ),
                SizedBox(width: 8),
                Text('Ultima atualização: 30/06/20/24 12:39',
                style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){},
                  child: Text('Exportar contagem'),
                ),
                SizedBox(width: 8),
                Text('Ultima exportação: 30/06/20/24 12:39',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}

