import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/storage/presentation/router/storage_router.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/cards/customer_storage_card.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/cards/user_storage_card.dart';

class StoragePage extends ConsumerStatefulWidget {
  const StoragePage ({
    super.key
  });
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StoragePageState();
}

class StoragePageState extends ConsumerState<StoragePage>{

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Estoques"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(HomeRouter.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // StorageSearchScreen();
            },
            icon: Icon(Icons.search)
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(StorageRouter.storage_details.name);
                },
                child: UserStorageCard()
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Divider(
                color: scheme.surface,
                indent: 8,
                endIndent: 8,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return CustomerStorageCard();
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}