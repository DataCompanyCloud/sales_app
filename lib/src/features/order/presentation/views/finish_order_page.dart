import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FinishOrderPage extends ConsumerWidget {
  final String title;

  const FinishOrderPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0081F5),
          foregroundColor: Colors.white,
          title: Text(title),
          leading: Container(),
          actions: [
            IconButton(
                onPressed: () {
                  context.go('/home');
                },
                icon: Icon(Icons.close, color: Colors.white, size: 28)
            )
          ],
        ),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 48, left: 28, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF0081F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.person_add, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 4,
                          color: Color(0xFF0081F5),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF0081F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.add_business, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 4,
                          color: Color(0xFF0081F5),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF0081F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.attach_money_sharp, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 4,
                              color: Color(0xFF0081F5),
                            ),
                          )
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF0081F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.check, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 240),
                  Column(
                    children: [
                      Icon(Icons.check_circle_outline, color: Color(0xFF0081F5), size: 56),
                      Padding(padding: EdgeInsets.only(top: 16)),
                      Text(
                        "Pedido registrado com sucesso!",
                        style: TextStyle(
                            color: Color(0xFF0081F5),
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 24)),
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Color(0xFF0081F5),
                          ),
                          icon: Icon(Icons.upload_file_outlined, size: 28),
                          label: Text(
                            "Gerar Boleto",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 12)),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              context.go('/home');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0081F5),
                                foregroundColor: Colors.white
                            ),
                            child: Text(
                              "Voltar",
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            )
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
        )
    );
  }
}