import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/dialogs/quit_dialog.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/indicator/step_indicator.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/textFields/textfield_create_customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:uuid/uuid.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart' as entity;


class CreateCompanyCustomerPage extends ConsumerStatefulWidget {
  const CreateCompanyCustomerPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CreateCompanyCustomerState();
}

class CreateCompanyCustomerState extends ConsumerState<CreateCompanyCustomerPage>{
  final List<String> steps = ['Dados', 'Endereço', 'Contato'];
  final currentStepProvider = StateProvider((ref) => 0);
  // Dados do cliente
  late final TextEditingController _legalNameController;
  late final TextEditingController _tradeNameController;
  late final TextEditingController _cnpjController;

  // Endereço
  late final TextEditingController _cepController;
  late final TextEditingController _stateController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;

  // Contato
  late final TextEditingController _emailController;
  late final TextEditingController _phoneCountryController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _legalNameController   = TextEditingController();
    _tradeNameController   = TextEditingController();
    _cnpjController        = TextEditingController();

    _cepController         = TextEditingController();
    _stateController       = TextEditingController();
    _cityController        = TextEditingController();
    _streetController      = TextEditingController();

    _emailController       = TextEditingController();
    _phoneCountryController= TextEditingController(text: '+55');
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _tradeNameController.dispose();
    _cnpjController.dispose();

    _cepController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _streetController.dispose();

    _emailController.dispose();
    _phoneCountryController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }


  void onStepTapped(int step) {
    ref.read(currentStepProvider.notifier).state = step;
  }

  void nextStep() {
    final currentStep = ref.read(currentStepProvider);
    if (currentStep < steps.length - 1) {
      ref.read(currentStepProvider.notifier).state++;
    }
  }

  void previousStep() {
    final currentStep = ref.read(currentStepProvider);
    if (currentStep > 0) {
      ref.read(currentStepProvider.notifier).state--;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentStepProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Novo Cliente - Empresa"),
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => QuitDialog()
            );
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: StepIndicator(
                    steps: ['Dados', 'Endereço', 'Contato'],
                    currentStep: currentStep,
                    onStepTapped: (step) {
                      onStepTapped(step);
                    },
                  ),
                ),
              ),
              /// informações dos cards aqui

              if (currentStep == 0) SafeArea(
                  child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 6, bottom: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Dados do Cliente",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ),
                    TextFieldCreateCustomer(controller: _legalNameController, hintText: "Razao social", icon: Icons.apartment_rounded),
                    SizedBox(height: 12,),
                    TextFieldCreateCustomer(controller: _tradeNameController, hintText: "Nome Fantasia", icon: Icons.apartment_rounded),
                    SizedBox(height: 12,),
                    TextFieldCreateCustomer(controller: _cnpjController, hintText: "CNPJ", icon: Icons.apartment_rounded),
                  ],
                )
              ),

              if (currentStep == 1) SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 6, bottom: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Endereço",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ),
                      TextFieldCreateCustomer(controller: _cepController, hintText: "CEP", icon: Icons.location_on),
                      SizedBox(height: 12,),
                      TextFieldCreateCustomer(controller: _stateController, hintText: "Estado"),
                      SizedBox(height: 12,),
                      TextFieldCreateCustomer(controller: _cityController, hintText: "Cidade"),
                      SizedBox(height: 12),
                      TextFieldCreateCustomer(controller: _streetController, hintText: "Rua"),
                    ],
                  )
              ),

              if (currentStep == 2) SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 6, bottom: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contato",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ),
                    TextFieldCreateCustomer(controller: _emailController, hintText: "E-mail", icon: Icons.location_on),
                    SizedBox(height: 12,),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFieldCreateCustomer(controller: _phoneCountryController, hintText: "+99", icon: Icons.phone,),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          flex: 3,
                          child: TextFieldCreateCustomer(controller: _phoneNumberController, hintText: "Número de Telefone"),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: currentStep < steps.length - 1
      ? FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          nextStep();
        },
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      )
      : FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          try {
            await ref.read(customerControllerProvider.notifier).createCustomer(createCustomerFaker());
            if (context.mounted) {
              context.goNamed(CustomerRouter.customer.name);
            }
          } catch (e) {
            print(e);
          }
        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      )
    );
  }
}

Customer createCustomerFaker() {
  final faker = Faker();

  var uuid = Uuid();

  Customer customer = Customer.company(
    customerId: 0,
    customerUuId: uuid.v4(),
    customerCode: 0.toString().padLeft(6, "0"),
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
  );

  // Troca para Customer.person aleatoriamente
  if (faker.randomGenerator.boolean()) {
    customer = Customer.person(
      customerId: 0,
      customerUuId: uuid.v4(),
      customerCode: 0.toString().padLeft(6, "0"),
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
      isActive: false,
    );
  }
  return customer;
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
