import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/storage/presentation/router/storage_router.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/cards/customer_storage_card.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/cards/user_storage_card.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/screens/storage_search_screen.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/skeleton/storage_list_skeleton.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StoragePage extends ConsumerStatefulWidget {
  const StoragePage ({
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StoragePageState();
}

class StoragePageState extends ConsumerState<StoragePage>{
  final toggleSearchButtonProvider = StateProvider<bool>((_) => false);

  void _showSearch() {
    final toggled = ref.read(toggleSearchButtonProvider.notifier);
    toggled.state = !toggled.state;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final controller = ref.watch(storageControllerProvider);
    final isSearchScreenOpen = ref.watch(toggleSearchButtonProvider);

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => StorageListSkeleton(),
      data: (pagination) {
        final storages = pagination.items;

        return Scaffold(
          appBar: AppBar(
            title: Text("Estoques"),
            leading: IconButton(
              onPressed: () {
                context.goNamed(HomeRouter.home.name);
              },
              icon: Icon(Icons.arrow_back_ios_new, size: 22),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: scheme.outline,
                height: 1.0,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showSearch,
                icon: Icon(isSearchScreenOpen ? Icons.close : Icons.search)
              ),
            ],
          ),
          body: SafeArea(
            child: isSearchScreenOpen
                ? StorageSearchScreen()
                : RefreshIndicator(
              onRefresh: () async {
                if (controller.isLoading) return;
                final _ = ref.refresh(storageControllerProvider);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    child: UserStorageCard(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      itemCount: storages.length,
                      itemBuilder: (context, i) {
                        final storage = storages[i];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('Clicando storageId: ${storage.storageId}');

                              context.pushNamed(
                                StorageRouter.storage_details.name, queryParameters: {'storageId': storage.storageId.toString()},
                                extra: {
                                  'isMyStorage': false,
                                }
                              );
                            },
                            child: CustomerStorageCard(storage: storage)
                          ),
                        );
                      }
                    ),
                  ),
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}