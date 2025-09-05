import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

class OrderDetailsList extends ConsumerWidget {
  const OrderDetailsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
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
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Nome do Produto ",
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                          TextSpan(
                            text: " x15",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                            )
                          )
                        ],
                      ),
                    ),
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
    );
  }
}