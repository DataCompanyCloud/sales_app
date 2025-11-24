import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/section/more_options_customer_section.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/section/more_options_order_section.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/section/more_options_product_section.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/section/more_options_storage_section.dart';
import 'package:sales_app/src/features/settings/providers.dart';

class MoreOptionsPage extends ConsumerWidget {

  const MoreOptionsPage ({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditable = ref.watch(isMoreOptionsEditableProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mais Opções"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                ref.read(isMoreOptionsEditableProvider.notifier).state = !isEditable;
              },
              icon: isEditable
                ? Icon(Icons.lock_outline)
                : Icon(Icons.lock_open_outlined)
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                MoreOptionsCustomerSection(),
                MoreOptionsStorageSection(),
                MoreOptionsOrderSection(),
                MoreOptionsProductSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
