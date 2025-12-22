import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/cards/storage_movement_details_card.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StorageMovementDetailsScreen extends ConsumerStatefulWidget {

  const StorageMovementDetailsScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StorageMovementDetailsScreenState();
}

class StorageMovementDetailsScreenState extends ConsumerState<StorageMovementDetailsScreen>{
  @override
  Widget build(BuildContext context) {
    // final status = ref.watch(storageMovementStatusFilterProvider);
    // final theme = Theme.of(context);
    // final scheme = theme.colorScheme;

    return Scaffold();

    // return controller.when(
    //   error: (error, stack) => ErrorPage(
    //     exception: error is AppException
    //       ? error
    //       : AppException.errorUnexpected(error.toString()),
    //   ),
    //   loading: () => Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   ),
    //   data: (storageMovementDetailsScreen) {
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           // StorageMovementStatusButton(
    //           //   countAll: countAll,
    //           //   countEntry: countEntry,
    //           //   countExit: countExit,
    //           //   countTransfer: countTransfer,
    //           //   countSynced: countSynced,
    //           //   countNotSynced: countNotSynced,
    //           // ),
    //           Expanded(
    //             child: SafeArea(
    //               child: ListView.builder(
    //                 itemCount: 15,
    //                 // itemCount: stockTransactions.length,
    //                 itemBuilder: (context, i) {
    //                   // final stockTransaction = stockTransactions[i];
    //
    //                   return Padding(
    //                     padding: const EdgeInsets.only(bottom: 4),
    //                     child: StorageMovementDetailsCard(),
    //                   );
    //                 }
    //               ),
    //             ),
    //           ),
    //           // Expanded(
    //           //   child: Builder(
    //           //     builder: (context) {
    //           //       int countAll = 0;
    //           //       int countEntry = 0;
    //           //       int countExit = 0;
    //           //       int countTransfer = 0;
    //           //       int countSynced = 0;
    //           //       int countNotSynced = 0;
    //           //
    //           //       final storageFiltered = storages.where((storage) {
    //           //         countAll++;
    //           //
    //           //         if (storage.serverId != null) {
    //           //           countSynced++;
    //           //         } else {
    //           //           countNotSynced++;
    //           //         }
    //           //
    //           //         if (storage.status == MovementType.stockIn) {
    //           //           countEntry++;
    //           //         } else if (storage.status == MovementType.stockOut) {
    //           //           countExit++;
    //           //         } else if (storage.status == MovementType.stockTransfer) {
    //           //           countTransfer++;
    //           //         }
    //           //
    //           //         if (status == StorageMovementStatusFilter.entry) {
    //           //           return storage.status == MovementType.stockIn;
    //           //         }
    //           //
    //           //         if (status == StorageMovementStatusFilter.exit) {
    //           //           return storage.status == MovementType.stockOut;
    //           //         }
    //           //
    //           //         if (status == StorageMovementStatusFilter.transfer) {
    //           //           return storage.status == MovementType.stockTransfer;
    //           //         }
    //           //
    //           //         if (status == StorageMovementStatusFilter.synced) {
    //           //           return storage.serverId != null;
    //           //         }
    //           //
    //           //         if (status != StorageMovementStatusFilter.notSynced) {
    //           //           return storage.serverId != null;
    //           //         }
    //           //
    //           //         return true;
    //           //       }).toList();
    //           //     }
    //           //   ),
    //           // ),
    //         ],
    //       ),
    //     );
    //   },
    // );

  }
}