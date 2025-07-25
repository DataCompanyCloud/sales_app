import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/presentation/controllers/sign_up_providers.dart';

class SignUpPage extends ConsumerWidget {
  final String title;

  const SignUpPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(signupViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
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
              /*
                Container(
                  // imagem aqui
                ),
                */
              Text(
                "Cadastre-se",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
              Padding(padding: EdgeInsets.all(16)),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Nome",
                    hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person),
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
              Padding(padding: EdgeInsets.all(16)),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF0081F5),
                      width: 2
                    )
                  ),
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
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Confirmar senha",
                  hintStyle: TextStyle(color: Colors.grey),
                  //
                  // Fazer função de confirmaçao de senha;
                  // ? confirmaçãoCorreta Icons.check_circle
                  // : confirmaçãoIncorreta Icons.close_sharp
                  //
                  prefixIcon: Icon(
                    Icons.cancel_sharp,
                    color: Colors.red,
                  ),
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
                  "Registrar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
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