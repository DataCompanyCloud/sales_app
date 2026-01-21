import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/screens/storage_movement_details_screen.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/screens/storage_product_details_screen.dart';

class StorageDetailsPage extends ConsumerStatefulWidget {
  final int storageId;
  final bool isMyStorage;

  const StorageDetailsPage({
    super.key,
    required this.storageId,
    required this.isMyStorage
  });

  @override
  ConsumerState<StorageDetailsPage> createState() => StorageDetailsPageState();
}

class StorageDetailsPageState extends ConsumerState<StorageDetailsPage>{
  final _tabBarIndexProvider = StateProvider<int>((ref) => 0);

  @override
  Widget build(BuildContext context) {
    final tabBarIndex = ref.watch(_tabBarIndexProvider);

    final storageId = widget.storageId;

    return DefaultTabController(
      length: 2,
      initialIndex: tabBarIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do Estoque"),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.grey,
            onTap: (index) => ref.read(_tabBarIndexProvider.notifier).state = index,
            tabs: const [
              Tab(text: "Produtos"),
              Tab(text: "Movimentação"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StorageProductDetailsScreen(storageId: storageId),
            StorageMovementDetailsScreen()
          ]
        ),
      ),
    );
  }
}