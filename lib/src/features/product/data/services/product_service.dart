import 'dart:math';
import 'package:faker/faker.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/product/domain/entities/barcode.dart';
import 'package:sales_app/src/features/product/domain/entities/image.dart';
import 'package:sales_app/src/features/product/domain/entities/packing.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/entities/unit.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';
import 'package:sales_app/src/features/product/domain/entities/category.dart' as entity;

class ProductService {
  final List<Product> products = createProductFaker(50);
  final ProductRepository repository;

  final ApiClient apiClient;

  ProductService(this.apiClient, this.repository);

  Future<List<Product>> getAll({int start = 0, int end = 30}) async {
    // final json = await apiClient.get<List<dynamic>>(ApiEndpoints.products(start: start, end: end));
    //
    // final products = json
    //   .map((json) => Product.fromJson(json as Map<String, dynamic>))
    //   .toList();
    // await Future.delayed(Duration(seconds: 5));

    final subList = products.sublist(start, end);

    for (final product in subList) {
      await repository.insert(product);
    }

    return subList;
  }

  Future<Product?> getById(int productId) async {
    await Future.delayed(Duration(seconds: 3));

    final faker = Faker();
    if (faker.randomGenerator.integer(10, min: 1) > 5) {
      throw AppException(
        AppExceptionCode.CODE_005_PRODUCT_SERVER_NOT_FOUND,
        "Falha ao obter dados do produto $productId"
      );
    }

    final index = products.indexWhere((e) => e.productId == productId);

    if (index == -1) {
      return null;
    }

    return await repository.insert(products[index]);
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
    Unit(unitName: "Unidade",abbreviation: "UN"),
    Unit(unitName: "Caixa",abbreviation: "CX"),
    Unit(unitName: "Palete",abbreviation: "PL"),
    Unit(unitName: "Kilograma",abbreviation: "KG"),
  ];

  return random.element(units);
}

List<ImageEntity> createImages() {
  final images = [
    'assets/images/black_shirt.jpg',
    'assets/images/grey_sneakers.jpg'
  ];

  return List.generate(random.integer(images.length + 1, min: 0), (index) {
    return ImageEntity(
      imageId: index + 1,
      url: images[index]
    );
  });
}

List<entity.Category> createCategories() {
  final names = [
    'Calçado', 'Tênis', 'Corrida'
  ];

  return List.generate(random.integer(names.length + 1, min: 0), (index) {
    return entity.Category(
      categoryId: index + 1,
      name: names[index],
    );
  });
}

List<Packing> createPackings() {
  return List.generate(random.integer(5, min: 0), (index) {
    return Packing(
      packingId: index + 1,
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
      productId: id,
      code: id.toString().padLeft(8, "0"), // "00000001"
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