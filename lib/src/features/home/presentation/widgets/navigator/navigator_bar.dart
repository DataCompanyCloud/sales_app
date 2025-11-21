import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/home/presentation/controllers/home_providers.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final int currentIndex;

  const CustomBottomNavigationBar ({
    super.key,
    required this.currentIndex
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(homeViewModelProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 12, left: 8, right: 8),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(30)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor: colorScheme.secondary,
              backgroundColor: colorScheme.surface,
              showUnselectedLabels: true,
              onTap: (index) {
                ref.read(homeIndexProvider.notifier).state = 2;
                switch(index) {
                  case 0:
                    context.goNamed(ProductRouter.product.name);
                    break;
                  case 1:
                    context.goNamed(OrderRouter.create.name);
                    break;
                  case 2:
                    context.goNamed(HomeRouter.home.name);
                    break;
                  case 3:
                    context.goNamed(CustomerRouter.customer.name);
                    break;
                //   case 4:
                //     context.goNamed(ScheduleRouter.schedule.name);
                }
              },
              items: [
                viewModelProvider.buildNavItem(
                  index: 0,
                  iconData: Icons.shopping_bag,
                  label: "Catálogo",
                  currentIndex: currentIndex
                ),
                viewModelProvider.buildNavItem(
                  index: 1,
                  iconData: Icons.add_circle,
                  label: "Pedidos",
                  currentIndex: currentIndex
                ),
                viewModelProvider.buildNavItem(
                  index: 2,
                  iconData: Icons.home_filled,
                  label: "Início",
                  currentIndex: currentIndex
                ),
                viewModelProvider.buildNavItem(
                  index: 3,
                  iconData: Icons.person,
                  label: "Clientes",
                  currentIndex: currentIndex
                ),
                viewModelProvider.buildNavItem(
                  index: 4,
                  iconData: Icons.calendar_month,
                  label: "Agenda",
                  currentIndex: currentIndex
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}