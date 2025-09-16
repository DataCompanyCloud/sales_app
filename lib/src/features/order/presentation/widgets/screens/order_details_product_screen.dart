import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_list.dart';

class OrderDetailsProductScreen extends ConsumerStatefulWidget {
  const OrderDetailsProductScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OrderDetailsProductScreenState();
}

class OrderDetailsProductScreenState extends ConsumerState<OrderDetailsProductScreen>{
  final onClickProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
  }

  bool onClick = false;
  void toggleProductScreen() {
    onClick = !onClick;
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onClick = ref.watch(onClickProvider);

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
                    onPressed: () {
                      ref.read(onClickProvider.notifier).state = !onClick;
                    },
                    child: Icon(
                      onClick
                        ? Icons.view_list_sharp
                        : Icons.view_agenda
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: onClick
                ? OrderDetailsCard()
                // ? OrderDetailsCardSkeleton()
                : OrderDetailsList()
                // : OrderDetailsListSkeleton()
            ),
          ],
        )
      ),
    );
  }
}