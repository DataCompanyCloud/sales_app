import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:sales_app/src/widgets/image_widget.dart';
import 'package:uuid/uuid.dart';


class SelectProductBottomSheet extends ConsumerStatefulWidget {
  final Product product;

  const SelectProductBottomSheet({
    super.key,
    required this.product
  });

  @override
  ConsumerState<SelectProductBottomSheet> createState() => SelectProductBottomSheetState();
}

class SelectProductBottomSheetState extends ConsumerState<SelectProductBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final height = MediaQuery.of(context).size.height * 0.90;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            "#${product.code}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // CONTEÚDO SCROLLÁVEL
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // 🔥 Imagem principal reduzida
                        Container(
                          width: double.infinity,
                          height: 220, // <-- tamanho reduzido
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ImageWidget(
                            image: product.imagePrimary,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // 🔥 Prévias das imagens (se existirem)
                        if (product.imagesAll.isNotEmpty)
                          SizedBox(
                            height: 70, // tamanho dos thumbnails
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: product.images.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, i) {
                                final img = product.images[i];
                                return Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade300,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: ImageWidget(
                                    image: img,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        product.attributes.length,
                            (i) {
                          final attribute = product.attributes[i];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nome do atributo
                                Text(
                                  attribute.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Chips com valores
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                    attribute.values.length,
                                      (j) {
                                      final value = attribute.values[j];

                                      return Chip(
                                        label: Text(value.value),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    product.description != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Descrição",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product.description ?? ""
                            )
                          ],
                        )
                      : SizedBox.shrink()
                  ]
                ),
              ),
            ),
          ),

          // 🚀 RODAPÉ FIXO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final selected = SalesOrderProduct(
                      productUuId: const Uuid().v4(),
                      productId: product.productId,
                      productCode: product.code,
                      productName: product.name,
                      quantity: 1,
                      unitPrice: product.price,
                      fiscal: product.fiscal
                  );

                  Navigator.pop<SalesOrderProduct>(context, selected);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}