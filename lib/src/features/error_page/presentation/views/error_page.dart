import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

class ErrorPage extends ConsumerWidget {

  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Ops... Parece que algo deu errado.",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12)),
            Text("CODE: ${AppException.prefix}"),
          ],
        ),
      ),
    );
  }

}