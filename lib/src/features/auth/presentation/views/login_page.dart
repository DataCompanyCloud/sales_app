import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/auth/providers.dart';

class LoginPage extends ConsumerStatefulWidget {

  const LoginPage ({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LoginPageState();

}

class LoginPageState extends ConsumerState<LoginPage> {
  final toggleRememberProvider = StateProvider<bool>((_) => false);
  final toggleVisibilityProvider = StateProvider<bool>((_) => false);
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final toggleVisibility = ref.watch(toggleVisibilityProvider);
    final toggleRemember = ref.watch(toggleRememberProvider);
    final authState = ref.watch(authControllerProvider);

    final authError = authState.hasError && authState.error is AppException
        ? authState.error as AppException
        : null;

    String? loginError;
    String? passwordError;
    if (authError != null) {
      switch (authError.code) {
        case AppExceptionCode.CODE_014_USER_NOT_FOUND :
          loginError = authError.message;
          break;
        case AppExceptionCode.CODE_007_AUTH_INVALID_CREDENTIALS:
          loginError = authError.message;
          break;
        default:
          loginError = authError.message;
          break;
      }
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                  SizedBox(height: 48,),
                  Text(loginError ?? ""),
                  TextField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      hintText: "Login",
                      errorText: loginError,
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: toggleVisibility,
                    decoration: InputDecoration(
                      hintText: "Senha",
                      errorText: passwordError,
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          ref.read(toggleVisibilityProvider.notifier).state = !toggleVisibility;
                        },
                        icon: Icon(
                          toggleVisibility ? Icons.visibility : Icons.visibility_off
                        )
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                        color: Colors.blue,
                          width: 2
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => ref.read(toggleRememberProvider.notifier).state = !toggleRemember,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                toggleRemember ? Icons.check_box : Icons.check_box_outline_blank,
                                color: toggleRemember ? Colors.blue : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Lembrar de mim',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.passwordRecovery.name);
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
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading
                        ? null
                        : () {
          
                          if (_loginController.text.isEmpty || _passwordController.text.isEmpty) return;
          
                          ref.read(authControllerProvider.notifier)
                              .login(
                            _loginController.text,
                            _passwordController.text,
                            toggleRemember
                          );
                        },
                      style: ElevatedButton.styleFrom(
                          elevation: 4,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          backgroundColor: authState.isLoading ? Colors.grey : Color(0xFF0081F5),
                          foregroundColor: Colors.white
                      ),
                      child: Text(
                        authState.isLoading ? "Carregando" : "Entrar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        ),
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
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                      onPressed: () { /* … */ },
                      icon: Image.asset(
                        'assets/images/google_icon.png',
                        width: 24,
                        height: 24,
                      ),
                      label: const Text('Entrar com Google', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      context.goNamed(AppRoutes.passwordRecovery.name);
                    },
                    child: Text(
                      "Cadastre-se",
                      style: TextStyle(
                          color: Colors.blue
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}