import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
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
      extendBody: true,
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
                            product.description ?? "--",
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
                          const Spacer(),
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  border: Border.all(color: Color(0xFF222426), width: 4),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
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
                            product.price.toString(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))
                            )
                          ),
                          icon: const Icon(Icons.shopping_cart, size: 22),
                          label: const Text('Adicionar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: 0,
              right: 0,
              child: Center(
                child: _QtyStepper(
                  value: qty,
                  onChanged: (v) => setState(() => qty = v),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UShapeClipper extends CustomClipper<Path> {
  final double stepperWidth;
  final double stepperHeight;
  final double radius;

  UShapeClipper({
    required this.stepperWidth,
    required this.stepperHeight,
    this.radius = 0
  });

  @override
  Path getClip(Size size) {
    double cutWidth = stepperWidth + 20;
    double cutHeight = stepperHeight / 2 + 10;
    double radius = 30; // mesmo valor do BorderRadius

    Path path = Path();

    // canto superior esquerdo
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // até antes do recorte
    path.lineTo((size.width - cutWidth) / 2, 0);

    // recorte em U
    
    path.quadraticBezierTo(
      size.width / 2 - cutWidth / 2, cutHeight,
      size.width / 2, cutHeight - 2,
    );
    path.quadraticBezierTo(
      size.width / 2 + cutWidth / 2, cutHeight,
      (size.width + cutWidth) / 2, 0,
    );

    // linha até canto superior direito (menos o raio)
    path.lineTo(size.width - radius, 0);

    // canto superior direito
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // lado direito
    path.lineTo(size.width, size.height - radius);

    // canto inferior direito
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);

    // lado inferior
    path.lineTo(radius, size.height);

    // canto inferior esquerdo
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // fecha caminho
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
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

class CurvedActionBar extends StatelessWidget {
  const CurvedActionBar({
    super.key,
    required this.qty,
    required this.onQtyChanged,
    required this.priceText,
    required this.onAddToCart,
    this.addLabel = 'Adicionar no Carrinho',
    this.height = 120,
    this.bumpWidth = 160,
    this.bumpHeight = 22,
  });

  final int qty;
  final ValueChanged<int> onQtyChanged;
  final String priceText;
  final VoidCallback onAddToCart;
  final String addLabel;

  /// Altura total da barra
  final double height;

  /// Largura e altura do “galo” (a elevação central)
  final double bumpWidth;
  final double bumpHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = Theme.of(context).bottomAppBarTheme.color ?? scheme.surfaceContainerHigh;
    final tint = Theme.of(context).bottomAppBarTheme.surfaceTintColor ?? scheme.surfaceTint;
    final bg = ElevationOverlay.applySurfaceTint(base, tint, 3);

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Fundo curvo
              Positioned(
                child: CustomPaint(
                  painter: _CurvedBumpPainter(
                    color: bg,
                    cornerRadius: 16,
                    bumpWidth: bumpWidth,
                    bumpHeight: bumpHeight,
                    shadowOpacity: 0.25,
                  ),
                ),
              ),
              _QtyStepper(
                value: qty,
                onChanged: onQtyChanged,
              ),
              // Conteúdo principal
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Preço
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preço', style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 2),
                          Text(
                            priceText,
                            style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      // Botão
                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.shopping_cart, size: 22),
                          label: Text(addLabel, style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurvedBumpPainter extends CustomPainter {
  _CurvedBumpPainter({
    required this.color,
    required this.cornerRadius,
    required this.bumpWidth,
    required this.bumpHeight,
    this.shadowOpacity = 0.2,
  });

  final Color color;
  final double cornerRadius;
  final double bumpWidth;   // largura do “galo”
  final double bumpHeight;  // altura (quanto sobe)
  final double shadowOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final r = cornerRadius;
    final startX = (size.width - bumpWidth) / 2;
    final endX = startX + bumpWidth;

    final path = Path()
    // canto sup. esquerdo
      ..moveTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
    // topo reto até antes do “galo”
      ..lineTo(startX, 0)
    // sobe no “galo” (duas curvas suaves até o ápice e desce)
      ..quadraticBezierTo(startX + bumpWidth * 0.25, 0, size.width / 2, -bumpHeight)
      ..quadraticBezierTo(endX - bumpWidth * 0.25, 0, endX, 0)
    // topo reto até o canto sup. direito
      ..lineTo(size.width - r, 0)
      ..quadraticBezierTo(size.width, 0, size.width, r)
    // lados e base com cantos arredondados
      ..lineTo(size.width, size.height - r)
      ..quadraticBezierTo(size.width, size.height, size.width - r, size.height)
      ..lineTo(r, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - r)
      ..close();

    // preenchimento
    final fill = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant _CurvedBumpPainter old) {
    return color != old.color ||
      cornerRadius != old.cornerRadius ||
      bumpWidth != old.bumpWidth ||
      bumpHeight != old.bumpHeight ||
      shadowOpacity != old.shadowOpacity;
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
        border: Border.all(color: Color(0xFF222426), width: 4)
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepBtn(
              icon: Icons.remove,
              onTap: () => onChanged((value - 1).clamp(1, 9999)),
              foreground: scheme.onSurfaceVariant,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text('$value', style: textStyle),
            ),
            _StepBtn(
              icon: Icons.add,
              onTap: () => onChanged((value + 1).clamp(1, 9999)),
              foreground: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.icon,
    required this.onTap,
    required this.foreground,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 18, color: foreground),
      ),
    );
  }
}

//
// class DebugClipPainter extends CustomPainter {
//   final double stepperWidth;
//   final double stepperHeight;
//   final double radius;
//
//   DebugClipPainter({
//     required this.stepperWidth,
//     required this.stepperHeight,
//     this.radius = 30,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     double cutWidth = stepperWidth + 20;
//     double cutHeight = stepperHeight / 2 + 10;
//
//     Path path = Path();
//
//     // canto superior esquerdo
//     final double x1 = 0;
//     final double y1 = radius;
//     path.moveTo(x1, y1);
//     final double x2 = 0;
//     final double y2 = 0;
//     path.quadraticBezierTo(x2, y2, 30, y2);
//
//     // linha até antes do recorte
//     final double x3 = size.width / 2 - 50;
//     final double y3 = 0;
//     path.lineTo(x3, y3);
//
//     // recorte U
//     final double x4 = size.width / 2 - 50;
//     final double y4 = cutHeight - 0;
//     final double x5 = size.width / 2;
//     final double y5 = cutHeight + 10;
//     path.quadraticBezierTo(x4, y4, x5, y5);
//
//     final double x6 = size.width / 2 + 50;
//     final double y6 = cutHeight;
//     final double x7 = size.width / 2 + 50;
//     final double y7 = 0;
//     path.quadraticBezierTo(x6, y6, x7, y7);
//
//     // linha até canto superior direito (menos o raio)
//     final double x8 = size.width - radius;
//     final double y8 = 0;
//     path.lineTo(x8, y8);
//
//     // canto superior direito
//     final double x9 = size.width;
//     final double y9 = 0;
//     final double x10 = size.width;
//     final double y10 = radius;
//     path.quadraticBezierTo(x9, y9, x10, y10);
//
//     // lado direito
//     final double x11 = size.width;
//     final double y11 = size.height - radius;
//     path.lineTo(x11, y11);
//
//     // canto inferior direito
//     final double x12 = size.width;
//     final double y12 = size.height;
//     final double x13 = size.width - radius;
//     final double y13 = size.height;
//     path.quadraticBezierTo(x12, y12, x13, y13);
//
//     // lado inferior
//     final double x14 = radius;
//     final double y14 = size.height;
//     path.lineTo(x14, y14);
//
//     // canto inferior esquerdo
//     final double x15 = 0;
//     final double y15 = size.height;
//     final double x16 = 0;
//     final double y16 = size.height - radius;
//     path.quadraticBezierTo(x15, y15, x16, y16);
//
//     path.close();
//
//     // --- desenha o path normal ---
//     Paint borderPaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//     canvas.drawPath(path, borderPaint);
//
//     // --- desenha pontos de controle ---
//     Paint pointPaint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     void drawPoint(Offset p) {
//       canvas.drawCircle(p, 4, pointPaint);
//     }
//
//     // agora marca os pontos importantes
//     drawPoint(Offset(x1, y1)); // início canto sup. esq.
//     drawPoint(Offset(y1, x1));
//     drawPoint(Offset(x3, y3));
//     drawPoint(Offset(x4, y4));
//     drawPoint(Offset(x5, y5));
//     drawPoint(Offset(x6, y6));
//     drawPoint(Offset(x7, y7));
//     drawPoint(Offset(x8, y8));
//     drawPoint(Offset(x10, y10));
//     drawPoint(Offset(x11, y11));
//     drawPoint(Offset(x13, y13));
//     drawPoint(Offset(x14, y14));
//     drawPoint(Offset(x16, y16));
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }