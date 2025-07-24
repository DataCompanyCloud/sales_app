import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_providers.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_company_customer_address_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_company_customer_contact_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/create_company_customer_info_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/dialogs/quit_dialog.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/indicator/step_indicator.dart';

class CreateCompanyCustomer extends ConsumerWidget {
  final String title;

  const CreateCompanyCustomer ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(customerViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text(title),
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
                    currentStep: viewModelProvider.currentStep,
                    onStepTapped: viewModelProvider.onStepTapped,
                  ),
                ),
              ),
              /// informações dos cards aqui
              if (viewModelProvider.currentStep == 0) CreateCompanyCustomerInfoCard(),

              if (viewModelProvider.currentStep == 1) CreateCompanyCustomerAddressCard(),

              if (viewModelProvider.currentStep == 2) CreateCompanyCustomerContactCard(),
            ],
          ),
        ),
      ),

      floatingActionButton: viewModelProvider.currentStep < viewModelProvider.steps.length - 1
      ? FloatingActionButton(
        backgroundColor: Color(0xFF0081F5),
        onPressed: () {
          viewModelProvider.nextStep();
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