import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/customer_filter.dart';
import 'package:sales_app/src/features/customer/providers.dart';


// TODO precisa melhorar o Filtro do customer
final TextEditingController _controllerCode = TextEditingController();
final TextEditingController _controllerName= TextEditingController();
final TextEditingController _controllerDocument= TextEditingController();
final TextEditingController _controllerEmail= TextEditingController();
final TextEditingController _controllerPhone= TextEditingController();

class DraggableCustomerFilter extends ConsumerWidget {

  const DraggableCustomerFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(customerFilterProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: 700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Filtro",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 12,
                              child: GestureDetector(
                                onTap: () {
                                  _controllerCode.text = "";
                                  _controllerName.text = "";
                                  _controllerDocument.text = "";
                                  _controllerEmail.text = "";
                                  _controllerPhone.text = "";
                                },
                                child: Text(
                                  'Limpar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                  ),
                                )
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              // Container(
                              //   height: 2,
                              //   width: double.infinity,
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey
                              //   ),
                              // ),
                              SizedBox(height: 12),
                              TextField(
                                controller: _controllerCode,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.credit_card),
                                  hintText: 'Código',
                                  labelText: 'Código',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: _controllerName,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  hintText: 'Razão Social/Nome Fantasia',
                                  labelText: 'Nome',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: _controllerDocument,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.account_balance),
                                  hintText: 'CPF/CNPJ',
                                  labelText: 'CPF/CNPJ',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: _controllerEmail,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: 'Email',
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: _controllerPhone,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  hintText: 'Telefone',
                                  labelText: 'Telefone',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
              // Botão “fixo” ao final:
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:  WidgetStatePropertyAll(Colors.blue)
                    ),
                    onPressed: () {
                      ref.read(customerFilterProvider.notifier).state = CustomerFilter(
                        customerCode: _controllerCode.text,
                        email: _controllerEmail.text,
                        name: _controllerName.text,
                        phone: _controllerPhone.text,
                        document: _controllerDocument.text
                      );
                      context.pop();
                    },
                    child: Text(
                      'Filtrar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
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