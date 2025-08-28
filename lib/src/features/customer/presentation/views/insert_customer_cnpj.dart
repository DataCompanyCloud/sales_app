import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';

class InsertCustomerCnpj extends ConsumerWidget {
  const InsertCustomerCnpj ({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Pessoa Jurídica"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onSurface
                  ),
                children: [
                  TextSpan(text: "Digite o "),
                  TextSpan(
                    text: "CNPJ ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    )
                  ),
                  TextSpan(text: "da empresa para preencher os dados cadastrais automaticamente.")
                ]
              ),
            ),
            SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: "XX.XXX.XXX/0001-XX",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.numbers_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Color(0xFF0081F5)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0081F5)
                      ),
                      child: Text(
                        "Confirmar",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 80,
                    endIndent: 12,
                  )
                ),
                Text(
                  "Ou",
                  style: TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 12,
                    endIndent: 80,
                  )
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                context.goNamed(CustomerRouter.createCompanyCustomer.name);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Cadastrar manualmente"),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}