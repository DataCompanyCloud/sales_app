import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/dialogs/quit_dialog.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/indicator/step_indicator.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/textFields/textfield_create_customer.dart';

class CreatePersonCustomerPage extends ConsumerStatefulWidget {
  const CreatePersonCustomerPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CreatePersonCustomerState();
}

class CreatePersonCustomerState extends ConsumerState<CreatePersonCustomerPage>{
  final List<String> steps = ['Dados', 'Endereço', 'Contato'];
  final currentStepProvider = StateProvider((ref) => 0);
  // Dados do cliente
  late final TextEditingController _legalNameController;
  late final TextEditingController _legalEmailController;
  late final TextEditingController _legalCpfController;

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
    _legalNameController = TextEditingController();
    _legalCpfController = TextEditingController();

    _cepController    = TextEditingController();
    _stateController  = TextEditingController();
    _cityController   = TextEditingController();
    _streetController = TextEditingController();

    _emailController        = TextEditingController();
    _phoneCountryController = TextEditingController(text: '+55');
    _phoneNumberController  = TextEditingController();
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _legalEmailController.dispose();
    _legalCpfController.dispose();

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

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        title: Text("Novo Cliente - Pessoa"),
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => QuitDialog()
            );
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        )
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
                      ),
                    ),
                    TextFieldCreateCustomer(controller: _legalNameController, hintText: "Nome Completo", icon: Icons.person),
                    SizedBox(height: 12),
                    TextFieldCreateCustomer(controller: _legalCpfController, hintText: "CPF", icon: Icons.numbers_sharp),
                  ],
                ),
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
                      ),
                    ),
                    TextFieldCreateCustomer(controller: _cepController, hintText: "CEP", icon: Icons.location_on),
                    SizedBox(height: 12),
                    TextFieldCreateCustomer(controller: _stateController, hintText: "Estado"),
                    SizedBox(height: 12),
                    TextFieldCreateCustomer(controller: _cityController, hintText: "Cidade"),
                    SizedBox(height: 12),
                    TextFieldCreateCustomer(controller: _streetController, hintText: "Rua"),
                  ],
                ),
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
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
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
        ),
    );
  }
}