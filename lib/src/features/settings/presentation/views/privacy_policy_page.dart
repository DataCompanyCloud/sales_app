import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Política de Privacidade"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: scheme.outline,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sua privacidade é importante para nós. Esta Política de Privacidade descreve como coletamos, usamos, armazenamos e protegemos as suas informações ao utilizar nosso aplicativo.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.account_circle),
                    SizedBox(width: 6),
                    Text(
                      "Coleta de Informações",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Coletamos informações fornecidas diretamente por você, como nome, e-mail, telefone, endereço e dados necessários para concluir compras ou criar sua conta. Também podemos coletar informações automaticamente, como dados de uso, tipo de dispositivo e identificadores técnicos, para melhorar sua experiência no aplicativo.",
                  textAlign: TextAlign.justify,
                ),
          
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.open_in_new),
                    SizedBox(width: 6),
                    Text(
                      "Uso das Informações",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text("As informações coletadas são utilizadas para:"),
                SizedBox(height: 12),
                Text(
                  "• Processar pedidos e transações;\n"
                  "• Melhorar o funcionamento do aplicativo;\n"
                  "• Oferecer suporte ao cliente;\n"
                  "• Enviar notificações importantes sobre sua conta ou compras;\n"
                  "• Personalizar ofertas e conteúdos relevantes.",
                  textAlign: TextAlign.justify,
                ),
          
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.offline_share),
                    SizedBox(width: 6),
                    Text(
                      "Compartilhamento de Informações",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Não vendemos suas informações pessoais. Podemos compartilhá-las apenas com parceiros e serviços essenciais para o funcionamento do app (como meios de pagamento e logística), sempre seguindo padrões rigorosos de segurança e confidencialidade.",
                  textAlign: TextAlign.justify,
                ),
          
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.shield),
                    SizedBox(width: 6),
                    Text(
                      "Segurança",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Adotamos medidas técnicas e administrativas para proteger seus dados contra acessos não autorizados, perdas e modificações.",
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}