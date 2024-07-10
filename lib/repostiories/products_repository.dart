import 'dart:io';

import 'package:auditoria/service/database_service.dart';
import 'package:flutter/material.dart';
import '../model/produto.dart';

class ProdustRepository with ChangeNotifier {
  List<Produtos> _products = [];

  List<Produtos> get products => _products;

  Future<void> loadProducts() async {
    final db = DataBaseService();
    final data = await db.getProducts();
    _products = data
        .map((item) => Produtos(
              ean: item['ean'],
              description: item['description'],
              complement: item['complement'],
              brand: item['brand'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> importProducts(String filePath) async {
    final db = DataBaseService();
    final file = File(filePath);
    final lines = await file.readAsLines();

    for (String line in lines) {
      final fields = line.split(';');
      if (fields.length >= 4) {
        final product = Produtos(
            ean: fields[0].trim(),
            complement: fields[1].trim(),
            description: fields[2].trim(),
            brand: fields[3].trim());
      }
    }
    await loadProducts();
  }
}
