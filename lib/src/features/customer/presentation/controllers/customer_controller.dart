import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/src/features/customer/domain/entities/cep.dart';
import 'package:sales_app/src/features/customer/domain/entities/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/entities/company_customer.dart';
import 'package:sales_app/src/features/customer/domain/entities/cpf.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/entities/email.dart';
import 'package:sales_app/src/features/customer/domain/entities/person_customer.dart';
import 'package:sales_app/src/features/customer/domain/entities/phone.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_person_customer_address_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_person_customer_contact_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_person_customer_info_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/units/document_generator.dart';
import 'package:sales_app/src/features/customer/domain/entities/address.dart' as entity;

enum CustomerFilter {
  all,
  active,
  inactive
}

class CustomerViewModel extends ChangeNotifier {
  final List<Customer> customers = createCustomerFaker(2000);

  bool isEditing = false;

  late CustomerFilter currentFilter = CustomerFilter.all;
  List<Customer> get filteredCustomers {
    if (currentFilter == CustomerFilter.active) {
      return customers.where((c) => c.isActive).toList();
    }

    if (currentFilter == CustomerFilter.inactive) {
      return customers.where((c) => !c.isActive).toList();
    }

    return customers;
  }

  // CreateCustomer
  int currentStep = 0;

  List<Widget> steps = [
    CreatePersonCustomerInfoCard(),
    CreatePersonCustomerAddressCard(),
    CreatePersonCustomerContactCard(),
  ];

  void nextStep() {
    if (currentStep < steps.length - 1) {
      currentStep ++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep --;
      notifyListeners();
    }
  }
  //

  void changeFilter(CustomerFilter filter) {
    currentFilter = filter;
    notifyListeners();
  }

  Customer? getCustomerById(int customerId) {
    final index = customers.indexWhere((element) => element.customerId == customerId);

    if(index != -1) {
      return customers[index];
    }

    return null;
  }

  void addCustomer(Customer customer) {
    // validações
    // separar
  }

  void updateCustomer(Customer newCustomer){
    final index = customers.indexWhere((element) => element.customerId == newCustomer.customerId);

    if(index != -1) {
      // Troca na entidade

      isEditing = false;
      notifyListeners();
    }
  }

  void activeIsEditing() {
    isEditing = true;
    notifyListeners();
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

List<Customer> createCustomerFaker(int quantity) {
  final List<Customer> output = List<Customer>.generate(quantity, (index) {
    final faker = Faker();
    final id = index + 1;

    if (faker.randomGenerator.boolean()) {
      return PersonCustomer(
        customerId: id,
        customerCode: id.toString().padLeft(6, "0"),
        fullName: faker.person.name(),
        cpf:  CPF(generateCpf(formatted: true)),
        email: Email(value: faker.internet.email()),
        phones: [Phone(value: gerarPhone())],
        address: entity.Address(
          state: faker.address.state(),
          city: faker.address.city(),
          street: faker.address.streetAddress(),
          cep: CEP(generateCep(formatted: true))
        ),
        isActive: faker.randomGenerator.boolean(),
      );
    }

    return CompanyCustomer(
      customerId: id,
      customerCode: id.toString().padLeft(6, "0"),
      tradeName: faker.company.name(),
      legalName: faker.company.name(),
      cnpj: CNPJ(generateCnpj(formatted: true)),
      email: Email(value: faker.internet.email()),
      phones: [Phone(value: gerarPhone())],
      address: entity.Address(
        state: faker.address.state(), 
        city: faker.address.city(), 
        street: faker.address.streetAddress(), 
        cep: CEP(generateCep(formatted: true))
      ),
      isActive: faker.randomGenerator.boolean()
    );
  });

  return output;
}