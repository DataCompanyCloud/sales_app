import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';

class ForgotPasswordPage extends ConsumerWidget {
  final String title;

  const ForgotPasswordPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final viewModelProvider = ref.watch(passwordViewModelProvider);

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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.password_outlined,
                color: Colors.blue,
                size: 48,
              ),
              Text(
                textAlign: TextAlign.center,
                "Deseja recuperar sua senha\n e continuar?",
                style: TextStyle(
                  fontSize: 28
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 32)),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF0081F5),
                      width: 2
                    )
                  )
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 22)),
              ElevatedButton(
                onPressed: () {
                  context.goNamed(AppRoutes.login.name);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  backgroundColor: Color(0xFF0081F5),
                  foregroundColor: Colors.white
                ),
                child: Text(
                  "Enviar Código",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              TextButton.icon(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                ),
                label: Text(
                  "Voltar para login",
                  style: TextStyle(
                    color: Colors.black54
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