import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogOrderPrinter extends ConsumerWidget {
  const DialogOrderPrinter ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.print),
          SizedBox(width: 8),
          Text(
            "Imprimir Pedido",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        Center(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  icon: Icon(Icons.newspaper, size: 22),
                  label: Text(
                    "NFE",
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  icon: Icon(Icons.inventory, size: 22),
                  label: Text(
                    "Boleto",
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}