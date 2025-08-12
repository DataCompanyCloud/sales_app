import 'dart:math';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
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
  final ProductRepository repository;

  final ApiClient apiClient;

  ProductService(this.apiClient, this.repository);

  Future<List<Product>> getAll({int start = 0, int limit = 30, String? search}) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.products, queryParameters: {
      'search': search,
      'start': start,
      'limit': start,
    });

    final data = json['data'] as List<dynamic>;

    final products = data
        .map((p) {
      return Product.fromJson(p);
    }).toList();

    return products;
  }

  Future<Product> getById(int productId) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(
          ApiEndpoints.productById(productId: productId));
      return Product.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_002_CUSTOMER_SERVER_NOT_FOUND, "Produto não existe");
      }

      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter usuário");
    } catch (p) {
      throw AppException.errorUnexpected(e.toString());
    }
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
          ? faker.randomGenerator.decimal(min: 100, scale: 3).toStringAsFixed(2)
          : faker.randomGenerator.decimal(min: 10, scale: 3).toStringAsFixed(2)
      ),
      unit: createUnit(),
      images: createImages(),
      categories: createCategories(),
      packings: createPackings()
    );
  });

  return output;
}