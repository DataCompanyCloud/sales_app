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
              padding: const EdgeInsets.only(left: 24, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Informe o CNPJ:",
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
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
                /*
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 80,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0081F5)
                      ),
                      child: Icon(
                        Icons.send,
                        size: 24,
                        color: Colors.white,
                      )
                    ),
                  ),
                ),
                */
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
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
                        color: Colors.white
                      ),
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 32,
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
                      endIndent: 32,
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