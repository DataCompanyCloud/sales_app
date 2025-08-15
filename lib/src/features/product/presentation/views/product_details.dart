import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/presentation/widgets/skeleton/product_details_skeleton.dart';
import 'package:sales_app/src/features/product/providers.dart';

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
    // final controller = ref.watch(productDetailsControllerProvider(productId));

    final product = widget.product;
    final image = product.images.firstOrNull;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final imageUrl = image?.url;
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // ícones escuros
          statusBarBrightness: Brightness.light,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary,
              ),
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Conteúdo rolável
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER com imagem
                AspectRatio(
                  aspectRatio: 1.0,
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
                            return imageUrl == null
                              ? Image.asset(
                                'assets/images/not_found.png',
                                fit: BoxFit.cover,
                            )
                              : Image.network(imageUrl);
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
                                    ? colorScheme.primary
                                    : Colors.transparent,
                                  border: Border.all(
                                    color: colorScheme.primary
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
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título + rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Bakuchiol & Tamanu oil • 100ml',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant,),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text('4.5'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'Descrição:',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Divider(),
                          ),
                          ReadMoreText(
                            "Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição. ",
                            style: TextStyle(color: colorScheme.onSurface),
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: "Leia mais",
                            trimExpandedText: "Mostrar menos",
                            moreStyle: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            lessStyle: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Preço + Stepper de quantidade
                      Row(
                        children: [

                          const SizedBox(height: 200),
                          const Spacer(),
                          _QtyStepper(
                            value: qty,
                            onChanged: (v) => setState(() => qty = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 120,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(double.infinity, 120),
                painter: CurvedBarPainter(),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyStepper(
                    value: qty,
                    onChanged: (v) => setState(() => qty = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Preço', style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 2),
                          Text(
                              'R\$21.99',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: SizedBox(
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.shopping_cart, size: 22),
                            label: const Text(
                              'Adicionar no Carrinho',
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ),
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
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class CurvedBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // cor do fundo
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * 0.35, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5, 0, // ponto mais alto da curva
        size.width * 0.65, size.height * 0.3,
      )
      ..lineTo(size.width, size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
