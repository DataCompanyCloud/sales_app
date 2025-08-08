import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';

class ErrorScreen extends ConsumerWidget {
  final AppException exception;
  const ErrorScreen({
    super.key,
    required this.exception
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 96,
              color: Colors.red,
            ),
            Padding(padding: EdgeInsets.only(top: 18)),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Text(
                exception.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12)),
            Text(
              "CODE: ${exception.formatCode()}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 24)),
            TextButton.icon(
              onPressed: () {
                if (exception.code == AppExceptionCode.CODE_000_ERROR_UNEXPECTED) {
                  context.goNamed(HomeRouter.home.name);
                  return;
                }
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFF0081F5),
                size: 18,
              ),
              label: Text(
                "Voltar",
                style: TextStyle(
                  color: Color(0xFF0081F5),
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}