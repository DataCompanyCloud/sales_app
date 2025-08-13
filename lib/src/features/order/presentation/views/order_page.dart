import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/order/presentation/controllers/order_providers.dart';
import 'package:sales_app/src/features/order/presentation/widgets/indicator/order_step_indicator.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OrderPageState();
}

class OrderPageState extends ConsumerState<OrderPage>{
  final List<String> steps = ['addCliente', 'addProduto', 'financeiro', 'compraFinalizada'];
  final currentStepProvider = StateProvider((ref) => 0);

  void onStepTapped(int step) {
    ref.read(currentStepProvider.notifier).state = step;
  }

  void nextStep() {
    final currentStep = ref.read(currentStepProvider);
    if (currentStep < steps.length - 1) {
      ref.read(currentStepProvider.notifier).state++;
    }
  }

  void previousStep() {
    final currentStep = ref.read(currentStepProvider);
    if (currentStep > 0) {
      ref.read(currentStepProvider.notifier).state--;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(orderIndexProvider);
    final currentStep = ref.watch(currentStepProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text("Pedidos"),
        leading: IconButton(
            onPressed: () {
              context.goNamed(HomeRouter.home.name);
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.crisis_alert_outlined)
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn-go",
            backgroundColor: Color(0xFF0081F5),
            foregroundColor: Colors.white,
            onPressed: () {

            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 22, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: OrderStepIndicator(
                    steps: ['addCliente', 'addProduto', 'financeiro', 'compraFinalizada'],
                    currentStep: currentStep,
                    onStepTapped: (step) {
                      onStepTapped(step);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 12,
                      endIndent: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 80,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0081F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3
                            ),
                            child: Icon(
                              Icons.add,
                              size: 28,
                              color: Colors.white,
                            )
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
    );
  }
}