import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/auth/providers.dart';

class LoginPage extends ConsumerWidget {
  final String title;

  const LoginPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
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
                // controller: viewModelProvider.emailController,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Nome de Usuário",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      // color: viewModelProvider.invalidEmail
                      //   ? Colors.red
                      //   : Color(0xFF0081F5),
                      // width: 2
                    )
                  )
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              TextField(
                // controller: viewModelProvider.passwordController,
                keyboardType: TextInputType.visiblePassword,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                // obscureText: viewModelProvider.isVisible,
                decoration: InputDecoration(
                  hintText: "Senha",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // viewModelProvider.toggleVisibility();
                    },
                    icon: Icon(
                      // viewModelProvider.isVisible
                      //   ? Icons.visibility_off
                      //   : Icons.visibility
                      Icons.visibility
                    )
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      // color: viewModelProvider.invalidPassword
                      //   ? Colors.red
                      //   : Color(0xFF0081F5),
                      // width: 2
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // viewModelProvider.toggleRemember();
                        },
                        icon: Icon(
                          // viewModelProvider.isSelected
                          //   ? Icons.check_box
                          //   : Icons.check_box_outline_blank,
                          // color: viewModelProvider.isSelected
                          //   ? Colors.blue
                          //   : Colors.grey,
                          Icons.check_box
                        ),
                      ),
                      const Text(
                        "Lembrar de mim",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed(AppRoutes.userType.name);
                      // context.goNamed(AppRoutes.passwordRecovery.name);
                    },
                    child: Text(
                      "Esqueceu a senha?",
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
                  if (authState.isLoading) return;

                  authController.login('lucas', '123');
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  backgroundColor: authState.isLoading ? Colors.grey : Color(0xFF0081F5),
                  foregroundColor: Colors.white
                ),
                child: Text(
                  authState.isLoading ? "Carregando" : "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}