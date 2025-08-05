import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends ConsumerWidget {
  final String title;

  const ForgotPasswordPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(
                    color: Color(0xFF0081F5),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "Para alterar a senha entre em contato \ncom o nosso suporte",
                style: TextStyle(
                  fontSize: 18
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 32)),
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    backgroundColor: Color(0xFF0081F5),
                    foregroundColor: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.whatshot, size: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Entrar em contato",
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              TextButton.icon(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
                label: Text(
                  "Voltar para login",
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}