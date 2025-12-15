import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TermsOfUsePage extends ConsumerWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Termos de Uso"),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ao utilizar este aplicativo, você concorda com os presentes Termos de Uso. Caso não concorde com qualquer condição descrita abaixo, recomendamos que não utilize o aplicativo.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.smartphone),
                    SizedBox(width: 6),
                    Text(
                      "Uso do Aplicativo",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "O aplicativo destina-se à visualização, compra e venda de produtos disponibilizados na plataforma. O usuário compromete-se a utilizar o app de forma lícita, ética e de acordo com a legislação vigente.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 6),
                    Text(
                      "Cadastro e Conta",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Para realizar compras, pode ser necessário criar uma conta, fornecendo informações verdadeiras e atualizadas. O usuário é responsável por manter a confidencialidade de seus dados de acesso e por todas as atividades realizadas em sua conta.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.payments),
                    SizedBox(width: 6),
                    Text(
                      "Compras e Pagamentos",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Os preços, formas de pagamento e condições de entrega são informados no momento da compra. O aplicativo não se responsabiliza por erros causados por informações incorretas fornecidas pelo usuário.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.balance),
                    SizedBox(width: 6),
                    Text(
                      "Responsabilidades do Usuário",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text("O usuário compromete-se a:"),
                SizedBox(height: 12),
                Text(
                  "• Não utilizar o aplicativo para fins ilegais ou não autorizados;\n"
                  "• Não tentar acessar áreas restritas ou sistemas do aplicativo sem permissão;\n"
                  "• Não praticar atos que possam comprometer a segurança ou o funcionamento da plataforma.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.switch_access_shortcut),
                    SizedBox(width: 6),
                    Text(
                      "Limitação de Responsabilidade",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "O aplicativo não se responsabiliza por eventuais indisponibilidades temporárias, falhas técnicas ou interrupções causadas por fatores externos.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.list_alt),
                    SizedBox(width: 6),
                    Text(
                      "Alterações nos Termos",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Os Termos de Uso podem ser alterados a qualquer momento. As atualizações entrarão em vigor a partir de sua publicação no aplicativo.",
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