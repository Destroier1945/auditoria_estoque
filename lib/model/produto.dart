class Produtos {
  String ean;
  String description;
  String complement;
  String brand;

  Produtos(
      {required this.ean,
      required this.complement,
      required this.description,
      required this.brand});

  Map<String, dynamic> toMap() {
    return {
      'ean': ean,
      'decription': description,
      'complement': complement,
      'brand': brand,
    };
  }
}
