import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({ super.key });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Perfil"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 52, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.blue.shade800,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: scheme.surface,
                  child: Icon(Icons.person, size: 52),
                ),
              ),
            ),
            Text(
              "NomeUsuário",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                "CódigoUsuário",
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Informações Pessoais",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, 
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          Text(
                            "Editar",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF67B2FE)
                            ),
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 2, bottom: 4),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: scheme.onTertiary
                        ),
                        color: scheme.surface
                      ),
                      child: Text("Nome"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 8, bottom: 4),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: scheme.onTertiary
                        ),
                        color: scheme.surface
                      ),
                      child: Text("Sobrenome"),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: scheme.onTertiary
                  ),
                  color: scheme.surface
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 4),
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        )
                      ],
                    ),
                    Text("user@gmail.com")
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: scheme.onTertiary
                  ),
                  color: scheme.surface
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 4),
                        Text(
                          "Telefone",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        )
                      ],
                    ),
                    Text("+55 47 91234-4321")
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: scheme.onTertiary
                  ),
                  color: scheme.surface
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 4),
                        Text(
                          "Localização",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        )
                      ],
                    ),
                    Text("Rua das Flores, 123")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}