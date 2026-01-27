import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/auth/domain/valueObjects/password.dart';
import 'package:sales_app/src/features/auth/presentation/widgets/dialogs/biometric_error_dialog.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>{
  final _visibleTextProvider = StateProvider<bool>((_) => true);
  final _isLoadingProvider = StateProvider<bool>((_) => false);
  final _passwordController = TextEditingController();
  final _canCheckBiometricsProvider = FutureProvider.autoDispose((ref) async {
    final auth = LocalAuthentication();
    return await auth.canCheckBiometrics;
  });

  Future<void> _authPassword() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) return;

    ref.read(_isLoadingProvider.notifier).state = true;

    try {
      final user = await ref.read(authControllerProvider.future);
      if (user == null) return;

      final userPassword = Password.fromPlain(password);

      if (userPassword.encrypted == user.password) {
        await ref.read(authControllerProvider.notifier).authenticate();
      }
    } catch (e) {
      //TODO: mostar na tela Erro senha inválida
      // print(e);
    } finally {
      ref.read(_isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _authBiometric() async {
    final auth = LocalAuthentication();
    final check = await auth.canCheckBiometrics;

    if (!check) {
      return;
    }

    try {
      final auth = LocalAuthentication();
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Desbloqueie seu dispositivo',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );

      if (!didAuthenticate) {
        return;
      }

      await ref.read(authControllerProvider.notifier).authenticate();
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _authBiometric();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider);
    final isLoading = ref.watch(_isLoadingProvider);
    final toggleVisibility = ref.watch(_visibleTextProvider);
    final canCheckBiometrics = ref.watch(_canCheckBiometricsProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
          exception: error is AppException
              ? error
              : AppException.errorUnexpected(error.toString()),
    ),
      loading: () => CircularProgressIndicator(),
      data: (user) {
        final check = canCheckBiometrics.value ?? false;

        return Scaffold(
          backgroundColor: scheme.surfaceContainerHighest,
          appBar: AppBar(
            centerTitle: true,
            title: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: scheme.onPrimary
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 32
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: scheme.secondary,
                      width: 1
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: Icon(Icons.person, color: Colors.black87),
                    ),
                    title: Text("${user?.firstName}"),
                    subtitle: Text("${user?.code}"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 28),
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: toggleVisibility,
                  decoration: InputDecoration(
                    hintText: "Senha",
                    // errorText: passwordError,
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
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ElevatedButton(
                  onPressed: isLoading ? null : _authPassword,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    backgroundColor: isLoading ? Colors.grey : Color(0xFF67B2FE)
                  ),
                  child: Text(
                    isLoading
                    ? "Carregando" : "Entrar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                    if (!check) {
                      showDialog(
                        context: context,
                        builder: (context) => AuthErrorDialog()
                      );
                      return;
                    }

                    await _authBiometric();
                    },
                    child: Column(
                      children: [
                        Icon(Icons.fingerprint_rounded, size: 32),
                        Text(
                          "Entrar com \na digital",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}