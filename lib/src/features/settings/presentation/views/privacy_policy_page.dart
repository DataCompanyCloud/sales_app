import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Política de Privacidade"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32, left: 8, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.shield,
                size: 76,
              ),
            ),
            
            SizedBox(height: 32),
            Text(
              "Privacidade de Usuário",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 6),
            Text("Sua privacidade é importante para nós. Esta Política de Privacidade descreve como coletamos, usamos, armazenamos e protegemos as suas informações ao utilizar nosso aplicativo.",),

            SizedBox(height: 24),
            Text(
              "Compartilhamento de Informações",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 6),
            Text("Não vendemos suas informações pessoais. Podemos compartilhá-las apenas com parceiros e serviços essenciais para o funcionamento do app (como meios de pagamento e logística), sempre seguindo padrões rigorosos de segurança e confidencialidade."),

            SizedBox(height: 24),
            Text(
              "Segurança",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 6),
            Text("Adotamos medidas técnicas e administrativas para proteger seus dados contra acessos não autorizados, perdas e modificações.")
          ],
        ),
      ),
    );
  }


}