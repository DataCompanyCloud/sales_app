/*
import 'package:converter_screens_erp/presentation/listProductsPage/viewmodel/product_providers.dart';
import 'package:converter_screens_erp/presentation/listProductsPage/widgets/dialog_filter_selected.dart';
import 'package:converter_screens_erp/presentation/listProductsPage/widgets/display_grid_view.dart';
import 'package:converter_screens_erp/presentation/listProductsPage/widgets/display_list_view.dart';
import 'package:converter_screens_erp/presentation/listProductsPage/widgets/filter_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductView extends ConsumerWidget {
  final String title;

  const ProductView ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(productIndexProvider);
    final viewModelProvider = ref.watch(productViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.notifications)
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: Color(0xFF0081F5),
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) {
              ref.read(productIndexProvider.notifier).state = 0;
              switch(index) {
                case 0:
                  context.go('/product');
                  break;
                case 1:
                  context.go('/order');
                  break;
                case 2:
                  context.go('/home');
                  break;
                case 3:
                  context.go('/customer');
                  break;
                case 4:
                  context.go('/agenda');
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFF0081F5),
                          child: Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                            size: 32,
                          ),
                        )
                      ],
                    ),
                  ),
                label: "",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle, size: 28),
                  label: "Create Order"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled, size: 28),
                  label: "Home"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 28),
                  label: "Customers"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month, size: 28),
                  label: "Agenda"
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 90,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DialogFilterSelected()
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0081F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.filter_alt, color: Colors.white, size: 22)
                    ),
                  ),
                  SizedBox(width: 12),
                  SizedBox(
                    width: 90,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              builder: (context, scrollController) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 40,
                                            height: 4,
                                            margin: EdgeInsets.only(bottom: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Modos de Exibição",
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        ...[
                                          FilterOptionTile(
                                            icon: Icons.view_list,
                                            title: "Lista 1",
                                            onTap: () {
                                              context.pop();
                                              viewModelProvider.updateFilterType("Lista 1");
                                              viewModelProvider.selectedFilterType();
                                            }
                                          ),
                                          FilterOptionTile(
                                            icon: Icons.view_agenda,
                                            title: "Lista 2",
                                            onTap: () {
                                              context.pop();
                                              viewModelProvider.updateFilterType("Lista 2");
                                              viewModelProvider.selectedFilterType();
                                            }
                                          ),
                                          FilterOptionTile(
                                            icon: Icons.grid_view_sharp,
                                            title: "Grade 1",
                                            onTap: () {
                                              context.pop();
                                              viewModelProvider.updateFilterType("Grade 1");
                                              viewModelProvider.selectedFilterType();
                                            }
                                          ),
                                          FilterOptionTile(
                                            icon: Icons.grid_on_sharp,
                                            title: "Grade 2",
                                            onTap: () {
                                              context.pop();
                                              viewModelProvider.updateFilterType("Grade 2");
                                              viewModelProvider.selectedFilterType();
                                            }
                                          ),
                                        ]
                                      ]
                                    ),
                                  ),
                                );
                              }
                            );
                          }
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0081F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 22)
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final option = viewModelProvider.option;

                  if (viewModelProvider.option.isEmpty) {
                    return DisplayListView(listType: viewModelProvider.list1Option("Lista 1"));
                  }

                  if (option == "Lista 1") {
                    return DisplayListView(listType: viewModelProvider.option);
                  }

                  if (option == "Lista 2") {
                    return DisplayListView(listType: viewModelProvider.option);
                  }

                  if (option == "Grade 1") {
                    return DisplayGridView(listType: viewModelProvider.option);
                  }

                  if (option == "Grade 2") {
                    return DisplayGridView(listType: viewModelProvider.option);
                  }

                  return Center(child: CircularProgressIndicator(color: Color(0xFF0081F5))
                  );
                }
              )
            )
          ],
        ),
      )
    );
  }
}
*/