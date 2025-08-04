import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/error/presentation/views/error_screen.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';

class ErrorPage extends ConsumerWidget {
  final AppException exception;
  const ErrorPage({
    super.key,
    required this.exception
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (exception.code == AppExceptionCode.CODE_000_ERROR_UNEXPECTED) {
              context.goNamed(HomeRouter.home.name);
              return;
            }
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: ErrorScreen(exception: exception),
    );
  }

}