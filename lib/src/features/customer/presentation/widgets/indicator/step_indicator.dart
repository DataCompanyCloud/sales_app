import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepIndicator extends ConsumerWidget {
  final List<String> steps;
  final int currentStep;

  const StepIndicator ({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;

            IconData icon;
            switch (stepIndex) {
              case 0:
                icon = Icons.person_rounded;
                break;
              case 1:
                icon = Icons.location_on_rounded;
                break;
              case 2:
                icon = Icons.phone_rounded;
                break;
              default:
                icon = Icons.circle;
            }

            final isCurrent = currentStep == stepIndex;
            final isCompleted = currentStep > stepIndex;

            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent || isCompleted ? Color(0xFF0F4D86) : Colors.grey,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            );
          } else {
            final leftStep = (index - 1) ~/ 2;
            final isActive = currentStep > leftStep;

            return Flexible(
              child: Container(
                height: 2,
                color: isActive ? Color(0xFF0F4D86) : Colors.grey,
              ),
            );
          }
        }),
      ),
    );
  }
}