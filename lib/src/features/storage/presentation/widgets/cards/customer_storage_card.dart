import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';

class CustomerStorageCard extends ConsumerWidget {
  final Storage storage;

  const CustomerStorageCard({
    super.key,
    required this.storage
  });

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
                  color: scheme.primary
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                  ),
                  child: Icon(
                    Icons.warehouse,
                    color: scheme.onSurface,
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
                              Text(
                                storage.name,
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              ),
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