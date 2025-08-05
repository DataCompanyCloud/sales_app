import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/draggable/custom_draggable.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class DraggableCustomerFilter extends ConsumerWidget {
  const DraggableCustomerFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(customerFilterProvider);

    return DraggableScrollableSheet(
      expand: false,
      // initialChildSize: 0.2,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    color: Colors.blue,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Filtro",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 8,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Limpar',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey
                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
              // Botão “fixo” ao final:
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // ação do botão
                    },
                    child: Text('Filtrar'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}