import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/customer_filter.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart' as entity;
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';

class CustomerService {
  final List<Customer> customers = createCustomerFaker(100);
  final CustomerRepository repository;

  final ApiClient apiClient;

  CustomerService(this.apiClient, this.repository);

  Future<List<Customer>> getAll(CustomerFilter filter) async {
    // final json = await apiClient.get<List<dynamic>>(ApiEndpoints.customers(start: start, end: end));
    //
    // final customers = json
    //     .map((json) => Customer.fromJson(json as Map<String, dynamic>))
    //     .toList();
    // await Future.delayed(Duration(seconds: 5));

    final subList = customers.sublist(filter.page, filter.limit);
    return subList;
  }

  Future<Customer?> getById(int customerId) async {
    // await Future.delayed(Duration(seconds: 3));

    final faker = Faker();
    if (faker.randomGenerator.integer(10, min: 1) > 5) {
      throw AppException(
        AppExceptionCode.CODE_002_CUSTOMER_SERVER_NOT_FOUND,
        "Falha ao obter dados do cliente $customerId"
      );
    }

    final index = customers.indexWhere((e) => e.customerId == customerId);

    if (index == -1) {
      return null;
    }

    return await repository.save(customers[index]);
  }
}


String gerarStringAleatoria(int comprimento) {
  const caracteres = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return List.generate(comprimento, (index) => caracteres[random.nextInt(caracteres.length)]).join();
}

String gerarPhone() {
  final areaCode = faker.randomGenerator.integer(900, min: 100).toString();
  final prefix = faker.randomGenerator.integer(900, min: 100).toString();
  final suffix = faker.randomGenerator.integer(10000, min: 1000).toString().padLeft(4, '0');

  return '($areaCode) $prefix-$suffix';
}

String gerarEmail() {
  final firstName = faker.person.firstName().toLowerCase();
  final lastName = faker.person.lastName().toLowerCase();
  final number = faker.randomGenerator.integer(999, min: 1);

  return '$firstName.$lastName$number@gmail.com';
}

List<Customer> createCustomerFaker(int quantity) {
  final faker = Faker();
  final List<Customer> output = [];

  for (int index = 0; index < quantity; index++) {
    final id = index + 1;

    Customer customer = Customer.company(
      customerId: id,
      customerCode: id.toString().padLeft(6, "0"),
      tradeName: faker.company.name(),
      legalName: faker.company.name(),
      cnpj: CNPJ(value: generateCnpj(formatted: true)),
      email: Email(value: gerarEmail()),
      phones: [Phone(value: gerarPhone())],
      address: entity.Address(
        state: faker.address.state(),
        city: faker.address.city(),
        street: faker.address.streetAddress(),
        cep: CEP(value: generateCep(formatted: true)),
      ),
      isActive: faker.randomGenerator.boolean(),
      isSynced: faker.randomGenerator.boolean()
    );

    // Troca para Customer.person aleatoriamente
    if (faker.randomGenerator.boolean()) {
      customer = Customer.person(
        customerId: id,
        customerCode: id.toString().padLeft(6, "0"),
        fullName: faker.person.name(),
        cpf: CPF(value: generateCpf(formatted: true)),
        email: Email(value: gerarEmail()),
        phones: [Phone(value: gerarPhone())],
        address: entity.Address(
          state: faker.address.state(),
          city: faker.address.city(),
          street: faker.address.streetAddress(),
          cep: CEP(value: generateCep(formatted: true)),
        ),
        isActive: faker.randomGenerator.boolean(),
        isSynced: faker.randomGenerator.boolean()
      );
    }

    output.add(customer);
  }

  return output;
}



String generateCpf({bool formatted = true}) {
  final fakerGen = faker.randomGenerator;
  final baseNumbers = List<int>.generate(9, (_) => fakerGen.integer(10));

  int d1 = 0;
  for (int i = 0; i < 9; i++) {
    d1 += baseNumbers[i] * (10 - i);
  }
  d1 = (d1 * 10) % 11;
  if (d1 == 10) d1 = 0;

  int d2 = 0;
  for (int i = 0; i < 9; i++) {
    d2 += baseNumbers[i] * (11 - i);
  }
  d2 += d1 * 2;
  d2 = (d2 * 10) % 11;
  if (d2 == 10) d2 = 0;

  final digits = [...baseNumbers, d1, d2];
  final numbers = digits.join();

  if (!formatted) return numbers;

  return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
}

String generateCnpj({bool formatted = true}) {
  final fakerGen = faker.randomGenerator;
  final base = List<int>.generate(8, (_) => fakerGen.integer(10))
    ..addAll([0, 0, 0, 1]);

  const weight1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  const weight2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  int calcDigit(List<int> numbers, List<int> weights) {
    final sum = List.generate(weights.length, (i) => numbers[i] * weights[i])
        .reduce((a, b) => a + b);
    final mod = sum % 11;
    return mod < 2 ? 0 : 11 - mod;
  }

  final d1 = calcDigit(base, weight1);
  final d2 = calcDigit([...base, d1], weight2);

  final digits = [...base, d1, d2];
  final numbers = digits.join();

  if (!formatted) return numbers;

  return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12)}';
}

String generateCep ({bool formatted = true}) {
  final fakerGen = faker.randomGenerator;
  final digits = List.generate(8, (_) => fakerGen.integer(10)).join();

  if (!formatted) return digits;

  return '${digits.substring(0, 5)}-${digits.substring(5, 8)}';
}