import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageMovementDetailsCard extends ConsumerWidget {
  const StorageMovementDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline, width: 2)
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
    );
  }
}