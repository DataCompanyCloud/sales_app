import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsProductScreen extends ConsumerStatefulWidget {
  const OrderDetailsProductScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OrderDetailsProductScreenState();
}

class OrderDetailsProductScreenState extends ConsumerState<OrderDetailsProductScreen>{

  bool onClick = false;
  void toggleProductScreen() {
    onClick = !onClick;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(top: 12, right: 12),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.list),
                  ),
                ),
              ),
            ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 8),
            //     child: ListView.builder(
            //       padding: EdgeInsets.symmetric(horizontal: 4),
            //       itemCount: 6,
            //       itemBuilder: (context, index) {
            //         return Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(12),
            //             border: Border.all(color: scheme.onTertiary, width: 2)
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Stack(
            //                 alignment: Alignment.topCenter,
            //                 children: [
            //                   Column(
            //                     children: [
            //                       Container(
            //                         padding: EdgeInsets.only(bottom: 8),
            //                         width: 90,
            //                         height: 90,
            //                         decoration: BoxDecoration(
            //                           borderRadius: BorderRadius.only(
            //                             topLeft: Radius.circular(10),
            //                             bottomLeft: Radius.circular(10),
            //                           ),
            //                           color: Colors.white54
            //                         ),
            //                         child: ClipRRect(
            //                           borderRadius: BorderRadius.only(
            //                             topLeft: Radius.circular(10),
            //                             bottomLeft: Radius.circular(10)
            //                           ),
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ]
            //               ),
            //               Expanded(
            //                 child: Container(
            //                   height: 90,
            //                   decoration: BoxDecoration(
            //                     color: scheme.surface,
            //                     borderRadius: BorderRadius.only(
            //                       topRight: Radius.circular(10),
            //                       bottomRight: Radius.circular(10)
            //                     ),
            //                   ),
            //                   child: Padding(
            //                     padding: EdgeInsets.only(left: 8),
            //                     child: Row(
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       children: [
            //                         Expanded(
            //                           child: Column(
            //                             crossAxisAlignment: CrossAxisAlignment.start,
            //                             mainAxisAlignment: MainAxisAlignment.center,
            //                             children: [
            //                               Text(
            //                                 "Nome do Produto"
            //                               ),
            //                               Text(
            //                                 "Categoria"
            //                               ),
            //                               Text(
            //                                 "Preço"
            //                               ),
            //                               Text(
            //                                 "QtdProduto"
            //                               ),
            //                             ],
            //                           )
            //                         ),
            //                         Padding(
            //                           padding: const EdgeInsets.only(right: 12),
            //                           child: Icon(Icons.chevron_right, size: 28),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                  itemCount: 12,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nome do Produto",
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),
                            Text(
                              "x15",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 24),
                            Text(
                              "Preço",
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              )
            )
          ],
        )
      ),
    );
  }
}