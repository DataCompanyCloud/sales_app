import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_company_customer_address_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_company_customer_contact_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_company_customer_info_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/dialogs/quit_dialog.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/indicator/step_indicator.dart';

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

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text("Adicionar Cliente - Empresa"),
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
              if (currentStep == 0) CreateCompanyCustomerInfoCard(),

              if (currentStep == 1) CreateCompanyCustomerAddressCard(),

              if (currentStep == 2) CreateCompanyCustomerContactCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: currentStep < steps.length - 1
      ? FloatingActionButton(
        backgroundColor: Color(0xFF0081F5),
        onPressed: () {
          nextStep();
        },
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      )
      : FloatingActionButton(
        backgroundColor: Color(0xFF0081F5),
        onPressed: () {

        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      )
    );
  }
}