import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/sync/presentation/widgets/sections/load_card_test.dart';

class SyncPage extends ConsumerWidget {

  const SyncPage ({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronização"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SyncProductsSection(),
            SyncProductsSection(),
            SizedBox(height: 12,),
            // DownloadCard()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.goNamed(HomeRouter.home.name);
          // final user = ref.read(authControllerProvider);
          await ref.read(authControllerProvider.notifier).sync();
          return;
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}