import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/buttons/storage_movement_status_button.dart';

class StorageMovementDetailsScreen extends ConsumerWidget {
  const StorageMovementDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = ref.watch(storageControllerProvider);
    // final status = ref.watch(storageMovementStatusFilterProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // return controller.when(
    //   error: error,
    //   loading: loading
    //   data: data,
    // );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StorageMovementStatusButton(
          // countAll: countAll,
          // countEntry: countEntry,
          // countExit: countExit,
          // countTransfer: countTransfer,
          // countSynced: countSynced,
          // countNotSynced: countNotSynced,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.onTertiary, width: 2)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      color: Colors.green.shade600
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      child: Icon(
                        Icons.move_to_inbox_sharp,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green
                                    ),
                                    child: Text(
                                      "Entrada",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Text("Data-Hora")
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.onTertiary, width: 2)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      color: Colors.red.shade900
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      child: Icon(
                        Icons.fire_truck,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.red
                                    ),
                                    child: Text(
                                      "Saída",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Text("Data-Hora")
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.onTertiary, width: 2)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      color: Colors.blue
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      child: Icon(
                        Icons.compare_arrows,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue
                                    ),
                                    child: Text(
                                      "Transferência",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Text("Data-Hora")
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    // Expanded(
      //   child: Builder(
      //     builder: (context) {
      //       int countAll = 0;
      //       int countEntry = 0;
      //       int countExit = 0;
      //       int countTransfer = 0;
      //       int countSynced = 0;
      //       int countNotSynced = 0;
      //
      //       final storageFiltered = storages.where((storage) {
      //         countAll++;
      //
      //         if (storage.serverId != null) {
      //           countSynced++;
      //         } else {
      //           countNotSynced++;
      //         }
      //
      //         if (storage.status == MovementType.stockIn) {
      //           countEntry++;
      //         } else if (storage.status == MovementType.stockOut) {
      //           countExit++;
      //         } else if (storage.status == MovementType.stockTransfer) {
      //           countTransfer++;
      //         }
      //
      //         if (status == StorageMovementStatusFilter.entry) {
      //           return storage.status == MovementType.stockIn;
      //         }
      //
      //         if (status == StorageMovementStatusFilter.exit) {
      //           return storage.status == MovementType.stockOut;
      //         }
      //
      //         if (status == StorageMovementStatusFilter.transfer) {
      //           return storage.status == MovementType.stockTransfer;
      //         }
      //
      //         if (status == StorageMovementStatusFilter.synced) {
      //           return storage.serverId != null;
      //         }
      //
      //         if (status != StorageMovementStatusFilter.notSynced) {
      //           return storage.serverId != null;
      //         }
      //
      //         return true;
      //       }).toList();
      //     }
      //   ),
      // ),
    );
  }
}