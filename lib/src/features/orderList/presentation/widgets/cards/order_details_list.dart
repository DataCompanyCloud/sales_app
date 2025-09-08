import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

class OrderDetailsList extends ConsumerWidget {
  const OrderDetailsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: 12,
        padding: EdgeInsets.symmetric(horizontal: 18),
        itemBuilder: (context, index) {

          final productName = "${faker.food.cuisine()} ${faker.food.cuisine()} ${faker.food.cuisine()} ${faker.food.cuisine()}";
          final price = random.integer(100, min: 1);
          final quantity = random.integer(100, min: 1);

          return DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(0),
            dashPattern: const [4, 3],
            color: Colors.grey,
            strokeWidth: 1,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            customPath: (size) {
              return Path()
                ..moveTo(0, size.height)
                ..lineTo(size.width, size.height);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            productName,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                            color: scheme.secondaryContainer,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "x$quantity",
                            style: TextStyle(
                              fontSize: 16,
                              color: scheme.onSurface,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "R\$${price * quantity}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

