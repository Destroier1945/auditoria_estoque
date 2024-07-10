import 'dart:io';

import 'package:auditoria/repostiories/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late DateTime lastUpdate;
  late DateTime lastExport;

  @override
  void initState() {
    super.initState();
    lastUpdate = DateTime.now();
    lastExport = DateTime.now();
  }

  Future<void> _requestPermission() async {
    await Permission.storage.request();
  }

  Future<void> importData(BuildContext context) async {
    await _requestPermission();

    Directory? directory = await getApplicationCacheDirectory();
    final pathToFile = '${directory.path}/data.txt';
    final productProvider =
        Provider.of<ProdustRepository>(context, listen: false);
    await productProvider.importProducts(pathToFile);

    setState(() {
      lastUpdate = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Importação efetuada com sucesso'),
      ),
    );
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
                  ElevatedButton(
                    onPressed: () => importData(context),
                    child: Text('Importar cadastro'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Ultima atualização: ${lastUpdate.day}/${lastUpdate.month} às ${lastUpdate.hour}:${lastUpdate.minute}',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Exportar contagem'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    lastExport.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
