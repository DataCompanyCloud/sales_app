import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';

class CreateCustomer extends ConsumerWidget {

  const CreateCustomer ({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        title: Text("Novo Cliente"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 300,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2, // duas colunas
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1, // formato dos botões (largura x altura)
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.goNamed(CustomerRouter.insertCustomerCnpj.name);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apartment_rounded, size: 72),
                          Text(
                            "PJ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.goNamed(CustomerRouter.createPersonCustomer.name);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_rounded, size: 72),
                          Text(
                            "PF",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18, bottom: 18),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: "Selecione o tipo de cliente que deseja cadastrar "
                          ),
                          TextSpan(
                            text: "Pessoa Juridíca ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0081F5)
                            )
                          ),
                          TextSpan(
                            text: "ou ",
                            style: TextStyle(
                              color: scheme.onSurface
                            )
                          ),
                          TextSpan(
                            text: "Pessoa Física",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0081F5)
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}