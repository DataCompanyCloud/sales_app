import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DraggableFilterProduct extends ConsumerStatefulWidget {
  const DraggableFilterProduct({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DraggableFilterProductState();
}

class DraggableFilterProductState extends ConsumerState<DraggableFilterProduct>{

  @override
  Widget build(BuildContext context) {
    /// TODO: Finalizar filtro da página de produtos

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
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
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey[300]
                    ),
                  ),
                ),
                Text(
                  "Filtros",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 12)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Teste"),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8)
                        )
                      )
                    ),
                    onPressed: () {},
                    child: Text("Limpar tudo")
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8)
                        )
                      )
                    ),
                    onPressed: () {},
                    child: Text("Aplicar")
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