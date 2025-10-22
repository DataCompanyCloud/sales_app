import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/auth/providers.dart';

class PasswordAuthenticatorScreen extends ConsumerStatefulWidget {
  const PasswordAuthenticatorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PasswordAuthenticatorScreenState();
}

class PasswordAuthenticatorScreenState extends ConsumerState<PasswordAuthenticatorScreen>{
  late final TextEditingController _passwordController;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _passwordFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        case AppExceptionCode.CODE_007_AUTH_INVALID_CREDENTIALS :
          loginError = authError.message;
          break;
        default:
          loginError = authError.message;
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
            ),
            SizedBox(height: 24),
            Text(
              "SalesApp",
              style: TextStyle(
                fontSize: 24
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Desbloqueie seu dispositivo",
              style: TextStyle(
                fontSize: 16
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: "Senha",
                  errorText: passwordError,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: authState.isLoading
          ? null
          : () {

            if (_passwordController.text.isEmpty) return;

            ref.read(authControllerProvider.notifier);
          },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}