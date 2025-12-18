import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/sections/address_section.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/sections/contact_info_section.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/sections/credit_limit_section.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/sections/payment_method_section.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';
import 'package:sales_app/src/widgets/draggable/contact_info_draggable.dart';
import 'package:sales_app/src/widgets/formField/custom_text_field.dart';
import 'package:sales_app/src/widgets/draggable/address_draggable.dart';
import 'package:sales_app/src/widgets/draggable/payment_method_draggable.dart';
import 'package:sales_app/src/widgets/masks.dart';
import 'package:sales_app/src/widgets/validations/cpf_form_validate.dart';
import 'package:sales_app/src/widgets/validations/customer_form_validate.dart';
import 'package:uuid/v4.dart';

class CreatePersonCustomerPage extends ConsumerStatefulWidget {
  const CreatePersonCustomerPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CreatePersonCustomerState();
}

class CreatePersonCustomerState extends ConsumerState<CreatePersonCustomerPage>{
  final _cpfFormNotifier = StateNotifierProvider<CpfFormNotifier, CpfFormValidate>((ref) => CpfFormNotifier());
  final _customerFormProvider = StateNotifierProvider<CustomerFormNotifier, CustomerFormValidate>((ref) => CustomerFormNotifier());

  final _isLoadingProvider = StateProvider<bool>((_) => false);

  final _contactsProvider = StateProvider<List<ContactInfo>>((_) => []);
  final _addressesProvider = StateProvider<List<Address>>((_) => []);
  final _paymentMethodsProvider = StateProvider<List<PaymentMethod>>((_) => []);

  late final TextEditingController _fullNameController;
  late final TextEditingController _cpfController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _cpfController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_isLoadingProvider);

    final cpfForm = ref.watch(_cpfFormNotifier);
    final cpfFormNotifier = ref.read(_cpfFormNotifier.notifier);
    final customerForm = ref.watch(_customerFormProvider);
    final customerFormNotifier = ref.read(_customerFormProvider.notifier);

    final paymentMethods = ref.watch(_paymentMethodsProvider);
    final addresses = ref.watch(_addressesProvider);
    final contacts = ref.watch(_contactsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        title: Text("Novo Cliente - PF"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (_) => const ConfirmationDialog(
                title: 'Sair do cadastro?',
                description: 'As informações preenchidas não serão salvas.',
                confirmText: 'Sair',
                cancelText: 'Continuar',
              ),
            );

            if (confirmed == true && context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: scheme.outline, // cor da linha
            height: 1.0,                 // espessura da linha
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                children: [
                  CustomTextField(
                    isLoading: isLoading,
                    controller: _fullNameController,
                    labelText: "Nome Completo",
                    required: true,
                    hintText: "Ex: Almir Farias",
                    errorText: customerForm.fullNameError,
                  ),
                  SizedBox(height: 2),
                  CustomTextField(
                    isLoading: isLoading,
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    masks: [Masks.cpf],
                    labelText: "CPF",
                    required: true,
                    hintText: "000.000.000-00",
                    errorText: cpfForm.cpfError ?? customerForm.cpfError,
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
              thickness: 4,
              color: scheme.outline,
            ),
            SizedBox(height: 20),
            AddressSection(
              onAddPressed: () async {
                final result = await showModalBottomSheet<Address>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddressDraggable(),
                );

                if (result == null) return;

                final notifier = ref.read(_addressesProvider.notifier);
                final current = notifier.state;

                final updated = current.map((c) => result.isPrimary
                    ? c.copyWith(isPrimary: false)
                    : c
                ).toList();

                notifier.state = [
                  ...updated,
                  result,
                ];
              },
              onDelete: (address) async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) =>ConfirmationDialog(
                    title: 'Excluir endereço ${address.isPrimary ? "padrão" : ""}',
                    description: 'Essa ação não poderá ser desfeita.',
                    confirmText: 'Excluir',
                    cancelText: 'Cancelar',
                    confirmIcon: Icons.delete_outline,
                    cancelIcon: Icons.close,
                    confirmButtonStyle: FilledButton.styleFrom(
                      backgroundColor: scheme.error,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                );

                if (confirmed != true) return;

                final notifier = ref.read(_addressesProvider.notifier);
                notifier.state = notifier.state
                    .where((item) => item != address)
                    .toList();
              },
              onEdit: (address) async {
                final result = await showModalBottomSheet<Address>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddressDraggable(initialValue: address),
                );

                if (result == null) return;

                final notifier = ref.read(_addressesProvider.notifier);
                final current = notifier.state;

                final replaced = current
                  .map(
                    (item) => item == address
                    ? result
                    : item.copyWith(
                      isPrimary: result.isPrimary ? false : item.isPrimary,
                    ),
                  ).toList();

                notifier.state = replaced;
              },
              addresses: addresses,
              required: true,
              errorMessage: customerForm.addressesError,
            ),
            SizedBox(height: 20),
            Divider(
              height: 2,
              thickness: 4,
              color: scheme.outline,
            ),
            SizedBox(height: 20),
            ContactInfoSection(
              onAddPressed: () async {
                final result = await showModalBottomSheet<ContactInfo>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ContactInfoDraggable(),
                );

                if (result == null) return;

                final notifier = ref.read(_contactsProvider.notifier);
                final current = notifier.state;

                final updated = current.map((c) => result.isPrimary
                  ? c.copyWith(isPrimary: false)
                  : c
                ).toList();

                notifier.state = [
                  ...updated,
                  result
                ];
              },
              onDelete: (contact) async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) =>ConfirmationDialog(
                    title: 'Excluir contato ${contact.isPrimary ? "padrão" : ""}',
                    description: 'Essa ação não poderá ser desfeita.',
                    confirmText: 'Excluir',
                    cancelText: 'Cancelar',
                    confirmIcon: Icons.delete_outline,
                    cancelIcon: Icons.close,
                    confirmButtonStyle: FilledButton.styleFrom(
                      backgroundColor: scheme.error,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                );

                if (confirmed != true) return;

                final notifier = ref.read(_contactsProvider.notifier);
                notifier.state = notifier.state
                  .where((item) => item != contact)
                  .toList();
              },
              onEdit: (contact) async {
                final result = await showModalBottomSheet<ContactInfo>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ContactInfoDraggable(initialValue: contact,),
                );

                if (result == null) return;

                final notifier = ref.read(_contactsProvider.notifier);
                final current = notifier.state;

                final replaced = current
                    .map(
                      (item) => item == contact
                      ? result
                      : item.copyWith(
                    isPrimary: result.isPrimary ? false : item.isPrimary,
                  ),
                ).toList();

                notifier.state = replaced;
              },
              required: true,
              contacts: contacts,
              errorMessage: customerForm.contactsError,
            ),
            SizedBox(height: 20),
            Divider(
              height: 2,
              thickness: 4,
              color: scheme.outline,
            ),
            SizedBox(height: 20),
            CreditLimitSection(),
            SizedBox(height: 20),
            Divider(
              height: 2,
              thickness: 4,
              color: scheme.outline,
            ),
            SizedBox(height: 20),
            PaymentMethodSection(
              onAddPressed: () async {
                final result = await showModalBottomSheet<List<PaymentMethod>>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => PaymentMethodDraggable(
                    selected: paymentMethods.toSet(),
                  ),
                );

                ref.read(_paymentMethodsProvider.notifier).state = result ?? paymentMethods;
              },
              onDelete: (method) {
                ref.read(_paymentMethodsProvider.notifier).state = paymentMethods.where((m) => m != method).toList();
              },
              paymentMethods: paymentMethods,
              required: true,
              errorMessage: customerForm.paymentMethodsError,
            ),
            SizedBox(height: 20),
            Divider(
              height: 2,
              thickness: 4,
              color: scheme.outline,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: scheme.outline, width: 2)
            )
          ),
          child: ElevatedButton(
            onPressed: () async {
              if (isLoading) return;
              ref.read(_isLoadingProvider.notifier).state = true;

              try {
                final cpf = cpfFormNotifier.validate(_cpfController.text);
                if (cpf == null) return;

                final newCustomer = customerFormNotifier.validate(
                  isPerson: true,
                  customerId: 0,
                  customerUuId: UuidV4().generate(),
                  cpf: cpf,
                  fullName: _fullNameController.text,
                  paymentMethods: paymentMethods,
                  contacts: contacts,
                  addresses: addresses,
                  isActive: true
                );

                if (newCustomer == null) return;

                if (!context.mounted) return;
                context.pop(newCustomer);
              } finally {
                ref.read(_isLoadingProvider.notifier).state = false;
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Finalizar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}