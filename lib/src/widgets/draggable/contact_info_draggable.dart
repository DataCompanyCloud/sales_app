import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/country_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone_type.dart';
import 'package:sales_app/src/widgets/formField/custom_text_field.dart';
import 'package:sales_app/src/widgets/formField/select_country_code.dart';
import 'package:sales_app/src/widgets/formField/single_select_checkbox_groupt.dart';
import 'package:sales_app/src/widgets/masks.dart';
import 'package:sales_app/src/widgets/validations/contact_info_form_validate.dart';
import 'package:sales_app/src/widgets/validations/email_form_validate.dart';
import 'package:sales_app/src/widgets/validations/phone_form_validate.dart';

class ContactInfoDraggable extends ConsumerStatefulWidget {
  final ContactInfo? initialValue;
  const ContactInfoDraggable({
    super.key,
    this.initialValue
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ContactInfoDraggableState();
}

class ContactInfoDraggableState extends ConsumerState<ContactInfoDraggable> {
  final _emailFormProvider = StateNotifierProvider<EmailFormNotifier, EmailFormValidate>((ref) => EmailFormNotifier());
  final _phoneFormProvider = StateNotifierProvider<PhoneFormNotifier, PhoneFormValidate>((ref) => PhoneFormNotifier());
  final _contactInfoFormProvider = StateNotifierProvider<ContactInfoFormNotifier, ContactInfoFormValidate>((ref) => ContactInfoFormNotifier());

  late final StateProvider<bool> _isLoadingProvider ;

  late final StateProvider<PhoneType> _phoneTypeProvider;
  late final StateProvider<CountryCode> _countryCodeSelectedProvider;
  late final StateProvider<bool> _isPrimaryProvider ;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final contact = widget.initialValue;

    _isLoadingProvider = StateProvider((_) => false);

    _phoneTypeProvider = StateProvider((_) => contact?.phone?.type ?? PhoneType.mobile);
    _countryCodeSelectedProvider = StateProvider((_) => contact?.phone?.countryCode ?? CountryCode.BR);
    _isPrimaryProvider = StateProvider((_) => contact?.isPrimary ?? false);

    _nameController = TextEditingController(text: contact?.name ?? "");
    _emailController = TextEditingController(text:  contact?.email?.value ?? "");
    _phoneController = TextEditingController(text: contact?.phone?.formattedNational ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactInfoForm = ref.watch(_contactInfoFormProvider);
    final contactInfoFormNotifier = ref.read(_contactInfoFormProvider.notifier);
    final phoneForm = ref.watch(_phoneFormProvider);
    final phoneFormNotifier = ref.read(_phoneFormProvider.notifier);
    final emailForm = ref.watch(_emailFormProvider);
    final emailFormNotifier = ref.read(_emailFormProvider.notifier);


    final isLoading = ref.watch(_isLoadingProvider);

    final phoneType = ref.watch(_phoneTypeProvider);
    final countryCodeSelected = ref.watch(_countryCodeSelectedProvider);
    final isPrimary = ref.watch(_isPrimaryProvider);

    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Novo Contato',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              // Lista
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          isLoading: isLoading,
                          labelText: "Nome",
                          required: true,
                          hintText: "Ex: Almir Farias",
                          errorText: contactInfoForm.nameError,
                        ),
                        const SizedBox(height: 2),
                        CustomTextField(
                          controller: _emailController,
                          isLoading: isLoading,
                          labelText: "Email",
                          required: true,
                          hintText: "Ex: exemplo@email.com",
                          errorText: emailForm.emailError ?? contactInfoForm.emailError,
                        ),
                        SizedBox(height: 8),
                        Divider(
                          height: 2,
                          thickness: 4,
                          color: scheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectCountryCodeState(
                              value: countryCodeSelected,
                              isLoading: isLoading,
                              required: true,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                isLoading: isLoading,
                                keyboardType: TextInputType.number,
                                controller: _phoneController,
                                labelText: "Telefone",
                                masks: [Masks.phone],
                                required: true,
                                hintText: "Ex: (00) 00000-0000",
                                errorText: phoneForm.phoneError ?? contactInfoForm.phoneError,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        SingleSelectCheckboxGroup<PhoneType>(
                          valueLabelBuilder: (state) => state.label,
                          onChanged: (type) {
                            ref.read(_phoneTypeProvider.notifier).state = type;
                          },
                          items: PhoneType.values,
                          isLoading: isLoading,
                          label: "Tipo do telefone",
                          required: true,
                          selected: phoneType
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                )
              ),
              // Botões
              SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2, color: scheme.outline)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              ref.read(_isPrimaryProvider.notifier).state = !isPrimary;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isPrimary ? scheme.primary : scheme.outline,
                                  width: 1.2,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Checkbox customizado
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isPrimary ? scheme.primary : scheme.outline,
                                        width: 2,
                                      ),
                                      color: isPrimary ? scheme.primary : Colors.transparent,
                                    ),
                                    child: isPrimary
                                      ? Icon(
                                          Icons.check,
                                          size: 12,
                                          color: scheme.onPrimary,
                                        )
                                      : null,
                                  ),

                                  const SizedBox(width: 8),

                                  // Textos
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Usar como contato principal',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Será escolhido automaticamente no pedido.',
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isLoading) return;
                                  // Limpa os erros antigos
                                  emailFormNotifier.setError();
                                  phoneFormNotifier.setError();
                                  contactInfoFormNotifier.setError();

                                  Email? email;
                                  if (_emailController.text.isNotEmpty) {
                                    email = emailFormNotifier.validate(_emailController.text);
                                    if (email == null) return;
                                  }

                                  Phone? phone;
                                  if (_phoneController.text.isNotEmpty) {
                                    phone = phoneFormNotifier.validate(value: _phoneController.text, type: phoneType, countryCode: countryCodeSelected);
                                    if (phone == null) return;
                                  }

                                  final newContactInfo = contactInfoFormNotifier.validate(
                                    name: _nameController.text,
                                    email: email,
                                    phone: phone,
                                    isPrimary: isPrimary
                                  );

                                  if (newContactInfo == null) return;

                                  Navigator.pop(context, newContactInfo);
                                },
                                child: const Text('Salvar'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension PhoneTypeX on PhoneType {
  IconData get icon {
    switch (this) {
      case PhoneType.mobile:
        return Icons.phone_android;
      case PhoneType.landline:
        return Icons.home;
      case PhoneType.whatsapp:
        return Icons.message;
      default:
        return Icons.phone;
    }
  }
}