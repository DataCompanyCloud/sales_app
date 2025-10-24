import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
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
  final _passwordController = TextEditingController();
  final _canCheckBiometricsProvider = FutureProvider.autoDispose((ref) async {
    final auth = LocalAuthentication();
    return await auth.canCheckBiometrics;
  });


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

      ref.read(authControllerProvider.notifier).authenticateByDigital();
    } catch (e) {
      print(e);
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
    final password = _passwordController.text.trim();
    final toggleVisibility = ref.watch(_visibleTextProvider);
    final canCheckBiometrics = ref.watch(_canCheckBiometricsProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // final authError = controller.hasError && controller.error is AppException
    //     ? controller.error as AppException
    //     : null;
    //
    // String? passwordError;
    // if (authError != null) {
    //   switch (authError.code) {
    //     case AppExceptionCode.CODE_014_USER_NOT_FOUND :
    //       passwordError = authError.message;
    //       break;
    //     case AppExceptionCode.CODE_007_AUTH_INVALID_CREDENTIALS :
    //       passwordError = authError.message;
    //       break;
    //     default:
    //       passwordError = authError.message;
    //       break;
    //   }
    // }

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
                    title: Text("${user?.userName}"),
                    subtitle: Text("${user?.userCode}"),
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
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              )
            ],
          ),

          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ElevatedButton.icon(
                  //   onPressed: () async {
                  //     if (!check) {
                  //       showDialog(
                  //         context: context,
                  //         builder: (context) => BiometricErrorDialog()
                  //       );
                  //       return;
                  //     }
                  //
                  //     await _authBiometric();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     minimumSize: Size(double.infinity, 40),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30)
                  //     )
                  //   ),
                  //   icon: Icon(
                  //     Icons.fingerprint_rounded,
                  //     size: 24,
                  //   ),
                  //   label: Text(
                  //     "Entrar com a digital",
                  //     style: TextStyle(
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
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
                  // TextButton(
                  //   onPressed: () {
                  //     // context.goNamed(AppRoutes.authPasswordPage.name);
                  //   },
                  //   child: Text(
                  //     "Entrar com a senha do aplicativo",
                  //     style: TextStyle(
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}