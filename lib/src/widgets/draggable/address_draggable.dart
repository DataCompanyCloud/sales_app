import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:sales_app/src/widgets/dialogs/dialog_brazilian_state.dart';
import 'package:sales_app/src/widgets/formField/custom_text_field.dart';
import 'package:sales_app/src/widgets/formField/select_brazilian_state.dart';
import 'package:sales_app/src/widgets/formField/single_select_checkbox_groupt.dart';
import 'package:sales_app/src/widgets/masks.dart';
import 'package:sales_app/src/widgets/validations/address_form_validate.dart';
import 'package:sales_app/src/widgets/validations/cep_form_validate.dart';


class AddressDraggable extends ConsumerStatefulWidget {
  final Address? initialValue;
  const AddressDraggable({
    super.key,
    this.initialValue
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddressDraggableState();
}

class AddressDraggableState extends ConsumerState<AddressDraggable> {
  final _addressFormProvider = StateNotifierProvider<AddressFormNotifier, AddressFormValidate>((ref) => AddressFormNotifier());
  final _cepFormProvider = StateNotifierProvider<CepFormNotifier, CepFormValidate>((ref) => CepFormNotifier());

  late final StateProvider<bool> _isLoadingProvider ;
  late final StateProvider<bool> _hasNoNumberProvider ;

  late final StateProvider<AddressType> _addressTypeProvider;
  late final StateProvider<BrazilianState?> _stateSelectedProvider ;
  late final StateProvider<bool> _isPrimaryProvider ;

  late final TextEditingController _cepController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;
  late final TextEditingController _districtController;
  late final TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    final address = widget.initialValue;

    _isLoadingProvider = StateProvider((_) => false);
    _hasNoNumberProvider = StateProvider((_) => address == null ? false : address.number == null ? true : false);

    _addressTypeProvider = StateProvider((_) => address?.type ?? AddressType.delivery);
    _stateSelectedProvider = StateProvider((_) => address?.state ?? BrazilianState.SC);
    _isPrimaryProvider = StateProvider((_) => address?.isPrimary ?? false);

    _cepController = TextEditingController(text: "89208300");
    _cityController = TextEditingController(text: address?.city ?? "");
    _streetController = TextEditingController(text:  address?.street ?? "");
    _districtController = TextEditingController(text: address?.district ?? "");
    _numberController = TextEditingController(text: (address?.number ?? "").toString());
  }

  @override
  void dispose() {
    _cepController.dispose();
    _cityController.dispose();
    super.dispose();
  }


  BrazilianState _brazilianStateFromUf(String uf) {
    return BrazilianState.values.firstWhere(
      (state) => state.name == uf.toUpperCase(),
      orElse: () => throw ArgumentError('UF inválida: $uf'), // TODO rever isso
    );
  }

  Future<void> _fetchAddressByCep({ required CEP cep}) async {
    final isLoading = ref.read(_isLoadingProvider);
    if (isLoading) return;
    ref.read(_isLoadingProvider.notifier).state = true;

    final notifier = ref.read(_cepFormProvider.notifier);
    notifier.setError(); // Limpa todos os erros
    try {
      final cleanCep = cep.value.replaceAll(RegExp(r'\D'), '');
      _streetController.text = ''; 
      _cityController.text = '';
      _districtController.text = '';

      // Validação básica
      if (cleanCep.length != 8) return;

      final uri = Uri.parse('https://viacep.com.br/ws/$cleanCep/json/');
      final response = await http.get(uri);

      if (response.statusCode != 200){
        notifier.setError(cepError: "Serviço de pesquisa indispónivel");
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // CEP inexistente
      if (data.containsKey("erro")) {
        notifier.setError(cepError: "CEP não encontrado ou não existe");
        return;
      }

      ref.read(_stateSelectedProvider.notifier).state = _brazilianStateFromUf(data['uf']);
      _streetController.text = data['logradouro'] ?? '';
      _cityController.text = data['localidade'] ?? '';
      _districtController.text = data['bairro'] ?? '';
    } catch(error) {
      print (error);
    } finally {
      ref.read(_isLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressForm = ref.watch(_addressFormProvider);
    final addressFormNotifier = ref.read(_addressFormProvider.notifier);
    final cepForm = ref.watch(_cepFormProvider);
    final cepFormNotifier = ref.read(_cepFormProvider.notifier);

    final hasNoNumber = ref.watch(_hasNoNumberProvider);
    final isLoading = ref.watch(_isLoadingProvider);

    final addressType = ref.watch(_addressTypeProvider);
    final stateSelected = ref.watch(_stateSelectedProvider);
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
                        'Novo Endereço',
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
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _cepController,
                                  isLoading: isLoading,
                                  keyboardType: TextInputType.number,
                                  labelText: "Cep",
                                  masks: [Masks.cep],
                                  required: true,
                                  hintText: "00000-000",
                                  errorText: cepForm.cepError ?? cepForm.formError,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: scheme.outline.withValues(alpha: 0.33),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: scheme.outline, width: 2),
                                      borderRadius: BorderRadius.circular(8), // ajuste aqui
                                    ),
                                  ),
                                  icon: const Icon(Icons.search),
                                  onPressed: () async {
                                    final cep = cepFormNotifier.validate(_cepController.text);
                                    if (cep == null) return;
                                    await _fetchAddressByCep(cep: cep);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
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
                            SelectBrazilianState(
                              onChange: () async {
                                final result = await showDialog<BrazilianState>(
                                  context: context,
                                  builder: (context) => DialogBrazilianState(
                                    selected: stateSelected,
                                  )
                                );

                                ref.read(_stateSelectedProvider.notifier).state = result ?? stateSelected;
                              },
                              value: stateSelected,
                              isLoading: isLoading,
                              required: true,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                controller: _cityController,
                                isLoading: isLoading,
                                labelText: "Cidade",
                                required: true,
                                hintText: "Ex: Curitiba",
                                errorText: addressForm.cityError,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        CustomTextField(
                          controller: _districtController,
                          isLoading: isLoading,
                          labelText: "Bairro",
                          required: true,
                          hintText: "Ex: Centro",
                          errorText: addressForm.districtError,
                        ),
                        const SizedBox(height: 2),
                        CustomTextField(
                          controller: _streetController,
                          isLoading: isLoading,
                          labelText: "Logradouro",
                          required: true,
                          hintText: "Ex: Rua XYZ",
                          errorText: addressForm.streetError,
                        ),
                        SizedBox(height: 2),
                        CustomTextField(
                          isLoading: isLoading,
                          keyboardType: TextInputType.number,
                          controller: _numberController,
                          labelText: "Número",
                          hintText: hasNoNumber ? "S/N" : "Ex: 123",
                          hasBottomMargin: false,
                          enabled: !hasNoNumber,
                          errorText: addressForm.numberError,
                        ),
                        SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            ref.read(_hasNoNumberProvider.notifier).state = !hasNoNumber;
                            if (!hasNoNumber) {
                              _numberController.text = "";
                              return;
                            }

                            _numberController.text = (widget.initialValue?.number ?? "").toString();
                          },
                          child: Row(
                            children: [
                              Icon(
                                hasNoNumber ? Icons.check_box : Icons.check_box_outline_blank
                              ),
                              SizedBox(width: 4),
                              Text("Sem Número")
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          height: 2,
                          thickness: 4,
                          color: scheme.outline,
                        ),
                        SizedBox(height: 16),
                        SingleSelectCheckboxGroup<AddressType>(
                          valueLabelBuilder: (state) => state.label,
                          onChanged: (type) {
                            ref.read(_addressTypeProvider.notifier).state = type;
                          },
                          items: AddressType.values,
                          isLoading: isLoading,
                          label: "Tipo do endereço",
                          required: true,
                          selected: addressType,
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
                                          'Usar como endereço principal',
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
                                  if (isLoading) return ;

                                  final cep = cepFormNotifier.validate(_cepController.text);
                                  if (cep == null) return;

                                  final number = int.tryParse(_numberController.text);
                                  final newAddress = addressFormNotifier.validate(
                                    state_: stateSelected,
                                    cep: cep,
                                    city: _cityController.text,
                                    district: _districtController.text,
                                    street: _streetController.text,
                                    number: number,
                                    type: addressType,
                                    isPrimary: isPrimary
                                  );

                                  if (newAddress == null) return;

                                  // salvar seleção
                                  Navigator.pop(context, newAddress);
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


extension AddressTypeX on AddressType {
  IconData get icon {
    switch (this) {
      case AddressType.billing:
        return Icons.receipt;
      case AddressType.delivery:
        return Icons.delivery_dining;
      default:
        return Icons.location_on;
    }
  }
}