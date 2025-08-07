import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';

class InsertCustomerCnpj extends ConsumerWidget {
  final String title;

  const InsertCustomerCnpj ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 18,
                        color: colorScheme.onSurface
                    ),
                  children: [
                    TextSpan(text: "Informe o "),
                    TextSpan(
                      text: "CNPJ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )
                    ),
                    TextSpan(text: " da empresa para que possamos \npreencher os dados cadastrais automaticamente.")
                  ]
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 80, right: 80),
                    child: TextField(
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
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: SizedBox(
                width: 320,
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0081F5)
                    ),
                    child: Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 64, bottom: 16),
              child: Row(
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