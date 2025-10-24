import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/auth/providers.dart';

class AuthPasswordPage extends ConsumerStatefulWidget{
  const AuthPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AuthPagePasswordState();
}

class AuthPagePasswordState extends ConsumerState<AuthPasswordPage>{
  final _visibleTextProvider = StateProvider<bool>((_) => false);
  final _isLoadingProvider = StateProvider<bool>((_) => false);
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
    final controller = ref.watch(authControllerProvider);
    final password = _passwordController.text.trim();
    final toggleVisibility = ref.watch(_visibleTextProvider);

    final authError = controller.hasError && controller.error is AppException
        ? controller.error as AppException
        : null;

    String? passwordError;
    if (authError != null) {
      switch (authError.code) {
        case AppExceptionCode.CODE_014_USER_NOT_FOUND :
          passwordError = authError.message;
          break;
        case AppExceptionCode.CODE_007_AUTH_INVALID_CREDENTIALS :
          passwordError = authError.message;
          break;
        default:
          passwordError = authError.message;
          break;
      }
    }

    ref.read(authControllerProvider.notifier).authenticateByPassword(password);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
          ),
          SizedBox(height: 16),
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
              obscureText: toggleVisibility,
              decoration: InputDecoration(
                hintText: "PIN",
                errorText: passwordError,
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.key),
                suffixIcon: IconButton(
                  onPressed: () {
                    ref.read(_visibleTextProvider.notifier).state = !toggleVisibility;
                  },
                  icon: Icon(
                    toggleVisibility ? Icons.visibility_off : Icons.visibility
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.isLoading
            ? null
            : () {
          if (password.isEmpty) return;

          ref.read(authControllerProvider.notifier).authenticateByPassword(password);
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