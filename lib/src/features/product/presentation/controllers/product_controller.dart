import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/src/features/product/domain/entities/barcode.dart';
import 'package:sales_app/src/features/product/domain/entities/category.dart';
import 'package:sales_app/src/features/product/domain/entities/image.dart';
import 'package:sales_app/src/features/product/domain/entities/packing.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/entities/unit.dart';

enum LayoutProduct {
  listSmallCard,
  listBigCard,
  gridColumn2,
  gridColumn3
}

class ProductViewModel extends ChangeNotifier{
  final List<Product> products = createProductFaker(100);

  LayoutProduct layoutProduct = LayoutProduct.gridColumn2;

  int currentPage = 0;

  void selectedImage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void updateLayout(LayoutProduct layout) {
    layoutProduct = layout;
    notifyListeners();
  }
}

String gerarStringAleatoria(int comprimento) {
  const caracteres = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return List.generate(comprimento, (index) => caracteres[random.nextInt(caracteres.length)]).join();
}

Barcode createBarcode() {
  return Barcode(
    type: 'CODE_128',
    value: gerarStringAleatoria(12),
  );
}

Unit createUnit() {
  final List<Unit> units = [
    Unit(name: "Unidade",abbreviation: "UN"),
    Unit(name: "Caixa",abbreviation: "CX"),
    Unit(name: "Palete",abbreviation: "PL"),
    Unit(name: "Kilograma",abbreviation: "KG"),
  ];

  return random.element(units);
}

List<ImageModel> createImages() {
  final images = [
    'assets/images/black_shirt.jpg',
    'assets/images/grey_sneakers.jpg'
  ];

  return List.generate(random.integer(images.length + 1, min: 0), (index) {
    return ImageModel(
        id: index + 1,
        url: images[index]
    );
  });
}

List<Category> createCategories() {
  final names = [
    'Calçado','Tênis', 'Corrida'
  ];

  return List.generate(random.integer(names.length + 1, min: 0), (index) {
    return Category(
      id: index + 1,
      name: names[index],
    );
  });
}

List<Packing> createPackings() {
  return List.generate(random.integer(5, min: 0), (index) {
    return Packing(
      id: index + 1,
      unit: createUnit(),
      barcode: faker.randomGenerator.boolean()
          ? null
          : createBarcode()
      ,
      quantity: faker.randomGenerator.boolean()
          ? random.decimal(min: 1)
          : random.decimal(min: 1, scale: 3),
    );
  });
}

List<Product> createProductFaker(int quantity) {
  final List<Product> output = List<Product>.generate(quantity, (index) {
    final faker = Faker();
    final id = index + 1;
    return Product(
        id: id,
        code: id.toString().padLeft(8, "0"),  // "00000001"
        name: "${faker.food.cuisine()} ${faker.food.dish()}",
        barcode: faker.randomGenerator.boolean()
            ? null
            : createBarcode()
        ,
        description: faker.randomGenerator.boolean()
            ? null
            : "${faker.food.cuisine()} ${faker.food.dish()}"
        ,
        price: double.parse(
            faker.randomGenerator.boolean()
                ? faker.randomGenerator.decimal(min: 60, scale: 3).toStringAsFixed(2)
                : faker.randomGenerator.decimal(min: 6, scale: 3).toStringAsFixed(2)
        ),
        unit: createUnit(),
        images: createImages(),
        categories: createCategories(),
        packings: createPackings()
    );
  });

  return output;
}