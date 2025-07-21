import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';

class CreateCustomer extends ConsumerWidget {
  final String title;

  const CreateCustomer ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text(title),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        context.goNamed(CustomerRouter.createPersonCustomer.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0081F5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      child: Icon(Icons.person_rounded, size: 72)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(CustomerRouter.createCompanyCustomer.name);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0081F5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          )
                        ),
                        child: Icon(Icons.apartment_rounded, size: 72)
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 18, bottom: 18),
                child: Column(
                  children: [
                    Text(
                      "Selecione o tipo de cliente que deseja cadastrar:",
                      style: TextStyle(fontSize: 18),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                        ),
                        children: [
                          TextSpan(
                            text: "Pessoa ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0081F5)
                            )
                          ),
                          TextSpan(
                            text: "ou ",
                            style: TextStyle(
                              color: colorScheme.onSurface
                            )
                          ),
                          TextSpan(
                            text: "Empresa",
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