import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DraggableFilterProduct extends ConsumerStatefulWidget {
  const DraggableFilterProduct({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DraggableFilterProductState();
}

class DraggableFilterProductState extends ConsumerState<DraggableFilterProduct>{
  final toggleFilterOptionProvider = StateProvider<bool>((_) => false);
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleFilterOption() {
    isSelected = !isSelected;
    super.dispose();
  }

  void clearAll() {
    ref.read(toggleFilterOptionProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final toggleFilter = ref.watch(toggleFilterOptionProvider);

    /// TODO: Finalizar filtro da página de produtos

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey[300]
                  ),
                ),
                Text(
                  "Filtros",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Produtos",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              ref.read(toggleFilterOptionProvider.notifier).state = !toggleFilter;
                            },
                            icon: Icon(
                              toggleFilter
                                ? Icons.circle
                                : Icons.circle_outlined
                            ),
                            label: Text("Roupas"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ref.read(toggleFilterOptionProvider.notifier).state = !toggleFilter;
                            },
                            icon: Icon(
                              toggleFilter
                                ? Icons.circle
                                : Icons.circle_outlined
                            ),
                            label: Text("Eletrônicos"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ref.read(toggleFilterOptionProvider.notifier).state = !toggleFilter;
                            },
                            icon: Icon(
                              toggleFilter
                                ? Icons.circle
                                : Icons.circle_outlined
                            ),
                            label: Text("Bijuteria"),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Promoções",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.circle_outlined),
                            label: Text("20%"),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.circle_outlined),
                            label: Text("40%"),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.circle_outlined),
                            label: Text("50%"),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Faixa de Preço",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 180,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money),
                                  labelText: "Valor mínimo",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money),
                                  labelText: "Valor máximo"
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8)
                          )
                        )
                      ),
                      onPressed: () {
                        clearAll();
                      },
                      child: Text("Limpar tudo")
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8)
                          )
                        )
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      child: Text("Aplicar")
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}