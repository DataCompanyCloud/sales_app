import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InsertCustomerCnpj extends ConsumerWidget {
  final String title;

  const InsertCustomerCnpj ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new)
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Inserir CNPJ"),
            Row(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "CNPJ",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.numbers_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFF0081F5)
                      )
                    )
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}