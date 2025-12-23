import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:sales_app/src/features/images/presentation/widgets/product_image_cached_widget.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

class ProductDetails extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetails({
    super.key,
    required this.product
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProductDetailsState();
}

class ProductDetailsState extends ConsumerState<ProductDetails>{
  final currentPage = ValueNotifier<int>(0);
  late final PageController pageController;
  int qty = 1;


  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = ref.watch(productDetailsControllerProvider);

    final product = widget.product;
    final image = product.images.firstOrNull;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    double screenHeight = MediaQuery.of(context).size.height;
    double fortyPercent = screenHeight * 0.4;

    // final imageUrl = image?.url;
    /// TODO: Finalizar a página de product_details
    // return controller.when(
    //   error: (error, stack) => ErrorPage(
    //     exception: error is AppException
    //       ? error
    //       : AppException.errorUnexpected(error.toString()),
    //   ),
    //   loading: () => ProductDetailsSkeleton(),
    //   data: (product) {
    //     return product.maybeMap(
    //       raw: (r) => ProductDetails(productId: productId),
    //       orElse: () => const Scaffold(body: SizedBox()),
    //     );
    //   },
    // );
    return Scaffold(
      backgroundColor: scheme.surface,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filled(
              onPressed: () {
                context.pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: scheme.primary
              ),
              icon: Icon(Icons.close, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // HEADER com imagem
                  SizedBox(
                    height: fortyPercent,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: 4,
                            onPageChanged: (index) {
                              currentPage.value = index;
                            },
                            itemBuilder: (context, index) {
                              return ProductImageCachedWidget(
                                productId: product.productId,
                                image: image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 8),
                          child: ValueListenableBuilder<int>(
                            valueListenable: currentPage,
                            builder: (_, page, _) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                4, (index) => AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 300),
                                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: page == index
                                      ? scheme.primary
                                      : Colors.transparent,
                                    border: Border.all(
                                      color: scheme.primary
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CONTEÚDO com cantos arredondados no topo
                  Container(
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                    ),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant,),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            product.categories.isEmpty
                              ? SizedBox()
                              : SizedBox(
                              height: 48,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  product.categories.length,
                                      (index) => Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: scheme.primary, width: 1),
                                      color: scheme.onSecondary,
                                    ),
                                    margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                                    child: Center(
                                      child: Text(product.categories[index].name),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Text(
                                  "R\$ ${product.price.decimalValue}",
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            product.attributes.isEmpty
                            ? SizedBox()
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: product.attributes.map((property) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          property.name,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 32,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          children: List.generate(
                                            property.values.length,
                                                (index) => Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: scheme.primary, width: 1),
                                                color: scheme.onSecondary,
                                              ),
                                              margin: const EdgeInsets.only(right: 8),
                                              child: Center(
                                                child: Text(property.values[index].value),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                              child: Divider(),
                            ),
                            product.description == null
                              ? SizedBox()
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      'Descrição',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  ReadMoreText(
                                    product.description ?? "Sem descrição",
                                    style: TextStyle(color: scheme.onSurface),
                                    trimLines: 2,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: "Leia mais",
                                    trimExpandedText: "Mostrar menos",
                                    moreStyle: TextStyle(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    lessStyle: TextStyle(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: scheme.onSecondary,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Preço Total',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.price.multiply(qty).decimalValue.toString(),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 46,
                          child: _QtyStepper(
                            value: qty,
                            onChanged: (v) => setState(() => qty = v),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            )
                          ),
                          icon: Icon(Icons.shopping_cart, size: 22,),
                          label: Text("Adicionar", style: TextStyle(fontSize: 16),)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12)
        ),
        border: Border.all(color: Color(0xFF222426), width: 2)
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () =>
                value <= 1
                  ? null
                  : onChanged((value - 1).clamp(1, 9999))
                ,
              icon: Icon(
                Icons.remove,
                color: value <= 1
                  ? Colors.grey.shade600
                  : scheme.onSurface
                ,
              )
            ),
            SizedBox(
              width: 40,
              child: TextFormField(
                controller: TextEditingController(text: value.toString()),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: textStyle,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  filled: false,
                ),
                onFieldSubmitted: (text) {
                  final intValue = int.tryParse(text.isEmpty ? '1' : text) ?? value;
                  final newValue = intValue.clamp(1, 9999);
                  onChanged(newValue);
                  FocusScope.of(context).unfocus();
                },
                validator: (text) {
                  if (text == null || text.isEmpty || text == '0') {
                    return 'Valor mínimo é 1';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              onPressed: () => onChanged((value + 1).clamp(1, 9999)),
              icon: Icon(
                Icons.add,
                color: scheme.onSurface,
              )
            )
          ],
        ),
      ),
    );
  }
}