import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/auth/presentation/controllers/login_providers.dart';

class LoginPage extends ConsumerWidget {
  final String title;

  const LoginPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(loginViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              Container(
                // imagem aqui
              ),
              */
              Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
              Padding(padding: EdgeInsets.all(16)),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "E-mail",
                  hintStyle: TextStyle(color: Colors.grey),
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
              Padding(padding: EdgeInsets.only(top: 16)),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                obscureText: viewModelProvider.isVisible,
                decoration: InputDecoration(
                  hintText: "Senha",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      viewModelProvider.toggleVisibility();
                    },
                    icon: Icon(
                      viewModelProvider.isVisible
                        ? Icons.visibility_off
                        : Icons.visibility
                    )
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF0081F5),
                      width: 2
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      context.goNamed(AppRoutes.passwordRecovery.name);
                    },
                    child: Text(
                      "Esquecer senha?",
                      style: TextStyle(
                        color: Colors.blue
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 22)),
              ElevatedButton(
                onPressed: () {
                  context.goNamed(AppRoutes.home.name);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 4,
                    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    backgroundColor: Color(0xFF0081F5),
                    foregroundColor: Colors.white
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ainda não possui uma conta?"),
                    TextButton(
                      onPressed: () {
                        context.goNamed(AppRoutes.signup.name);
                      },
                      child: Text(
                        "Cadastrar.",
                        style: TextStyle(
                            color: Colors.blue
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}