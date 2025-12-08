import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/attribute.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';
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
  late final TextEditingController controller;
  late final FocusNode focusNode;


  late final StateProvider<ImageEntity?> imagePreviewProvider;
  late final StateProvider<Map<int, Attribute>> selectAttributeProvider;

  @override
  void initState() {
    super.initState();
    imagePreviewProvider = StateProvider<ImageEntity?>((ref) => widget.product.imagePrimary);

    final attributes = widget.product.attributes;
    final Map<int, Attribute> attributesMap = {};
    for (var attribute in attributes) {
      if (attribute.values.isEmpty) continue;
      attributesMap[attribute.id] = attribute.copyWith(
        values: [attribute.values.first]
      );
    }
    selectAttributeProvider = StateProvider<Map<int, Attribute>>((ref) => attributesMap);

    controller = TextEditingController(text: "0");
    focusNode = FocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePreview = ref.watch(imagePreviewProvider);
    final selectAttributes = ref.watch(selectAttributeProvider);
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
          Column(
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
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "#${product.code}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 16,
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Icon(
                            Icons.close
                          ),
                        ),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          // CONTEÚDO SCROLLÁVEL
          Flexible(
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
                          child: SizedBox(
                            height: 220,
                            child: ImageWidget(
                              image: imagePreview,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // 🔥 Prévias das imagens (se existirem)
                        if (product.imagesAll.isNotEmpty)
                          SizedBox(
                            height: 70, // tamanho dos thumbnails
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: product.imagesAll.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, i) {
                                final img = product.imagesAll[i];

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(8),
                                    side: BorderSide(
                                      color: img == imagePreview ? scheme.primary : scheme.outline,
                                      width: 4
                                    )
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      ref.read(imagePreviewProvider.notifier).state = img;
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: ImageWidget(
                                        image: img,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
                        product.attributes.length, (i) {
                          final attribute = product.attributes[i];
                          final selected = selectAttributes[attribute.id];

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
                                      final isSelected = selected == null
                                          ? false
                                          : selected.values.first == value
                                      ;

                                      return InkWell(
                                        onTap: () {
                                          if (isSelected) return;
                                          final current = ref.read(selectAttributeProvider);

                                          // copia o mapa
                                          final updated = Map<int, Attribute>.from(current);

                                          // altera só a chave necessária:
                                          updated[attribute.id] = current[attribute.id]!.copyWith(values: [value]);

                                          // joga o novo estado:

                                          final image = value.imagePrimary ?? imagePreview;

                                          ref.read(imagePreviewProvider.notifier).state = image;
                                          ref.read(selectAttributeProvider.notifier).state = updated;

                                        },
                                        child: Chip(
                                          backgroundColor:
                                          isSelected
                                            ? scheme.primary
                                            : scheme.surfaceContainerHigh
                                          ,
                                          label: Text(
                                            value.value,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
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
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
            ),
            child: Column(
              children: [
                Text(
                  "R\$ ${product.price.format(scale: 2)}"
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4)
                              ),
                              side: BorderSide(color: scheme.outline, width: 2)
                          ),
                          child: InkWell(
                            onTap: () {
                              final current = max((int.tryParse(controller.text) ?? 0) -1, 0);
                              controller.text = current.toString();

                              // cart.setProductQuantity(product, current);

                              controller.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: controller.text.length,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.remove,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: scheme.outline, width: 2),
                              bottom: BorderSide(color: scheme.outline, width: 2)
                            )
                          ),
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              final n =  max(int.tryParse(text) ?? 0, 0);

                              // cart.setProductQuantity(product, n);
                            },
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              isCollapsed: true,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4)
                              ),
                              side: BorderSide(color: scheme.outline, width: 2)
                          ),
                          child: InkWell(
                            onTap: () {
                              final current = (int.tryParse(controller.text) ?? 0) + 1;
                              controller.text = current.toString();

                              // cart.setProductQuantity(product, current);

                              controller.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: controller.text.length,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16,),
                    Expanded(
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
                          child: Text(
                            controller.text == "0"
                            ? "Não"
                            : "Confirmar",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}