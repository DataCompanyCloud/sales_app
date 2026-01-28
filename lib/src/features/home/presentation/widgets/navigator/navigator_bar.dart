import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/features/schedule/presentation/router/schedule_router.dart';


class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  final int currentIndex;
  const CustomBottomNavigationBar ({
    super.key,
    required this.currentIndex
  });

  @override
  ConsumerState<CustomBottomNavigationBar> createState() => CustomBottomNavigationBarState();
}


class CustomBottomNavigationBarState extends ConsumerState<CustomBottomNavigationBar>{

  @override
  Widget build(BuildContext context) {
    // final viewModelProvider = ref.watch(homeViewModelProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final routeByIndex = <int, String>{
      0: ProductRouter.product.name,
      1: SalesOrderRouter.list.name,
      2: HomeRouter.home.name,
      3: CustomerRouter.customer.name,
      // 4: ScheduleRouter.schedule.name,
    };

    return SafeArea(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: scheme.outline, width: 2)
          )
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: widget.currentIndex,
            showUnselectedLabels: true,
            onTap: (index) {
              final routeName = routeByIndex[index];
              if (routeName == null) return; // evita crash se índice não existir
              context.goNamed(routeName);
            },
            items: [
              _buildNavItem(
                isSelected: false,
                iconData: Icons.shopping_bag,
                label: "Catálogo"
              ),
              _buildNavItem(
                isSelected: false,
                iconData: Icons.add_circle,
                label: "Pedidos"
              ),
              _buildNavItem(
                isSelected: false,
                iconData: Icons.home_filled,
                label: "Início"
              ),
              _buildNavItem(
                isSelected: false,
                iconData: Icons.person,
                label: "Clientes",
              ),
              _buildNavItem(
                isSelected: false,
                iconData: Icons.calendar_month,
                label: "Agenda",
              )
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required bool isSelected,
    required String label,
    required IconData iconData,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return BottomNavigationBarItem(
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: .14), // indicator suave
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.primary.withValues(alpha: .22)),
        ),
        child: Icon(iconData, size: 24, color: scheme.primary),
      ),
      icon: Icon(iconData, size: 24),
      label: label,
    );
  }
}