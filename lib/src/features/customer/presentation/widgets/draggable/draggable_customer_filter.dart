import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class DraggableCustomerFilter extends ConsumerWidget {
  const DraggableCustomerFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(customerFilterProvider);
    
    return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(

                  )
                ],
              )
            ),
          );
        }
    );
  }
}