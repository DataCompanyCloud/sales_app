import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sales_app/src/features/auth/presentation/widgets/screens/password_authenticator_screen.dart';
import 'package:sales_app/src/features/auth/providers.dart';

class DigitalAuthenticatorPage extends ConsumerStatefulWidget {
  const DigitalAuthenticatorPage({super.key});

  @override
  ConsumerState<DigitalAuthenticatorPage> createState() => _DigitalAuthenticatorPageState();
}

class _DigitalAuthenticatorPageState extends ConsumerState<DigitalAuthenticatorPage>{

  Future<void> _authenticate() async {
    final auth = LocalAuthentication();
    final canCheck = await auth.canCheckBiometrics;

    if (!mounted) return;

    if (!canCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Biometria não disponível neste dispositivo")),
      );
      return;
    }

    try {
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Desbloqueie seu celular',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );

      if (!mounted) return;

      if (didAuthenticate) {
        ref.read(biometricAuthProvider.notifier).state = true;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na autenticação: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blue[700]
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 82
          )
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => _authenticate(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Entrar com a digital",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.fingerprint_rounded,
                      size: 24,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: false,
                    builder: (context) => PasswordAuthenticatorScreen(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Entrar com a senha do aplicativo",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.key,
                      size: 24,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}