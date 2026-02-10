import 'package:dotted_line/dotted_line.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyCustomerFinancial extends ConsumerWidget {
  const CompanyCustomerFinancial({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    String generatePrice() {
      return faker.randomGenerator
          .decimal(scale: 10000, min: 1)
          .toStringAsFixed(2);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.monetization_on,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Informações Adicionais",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "Limite de Crédito",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Limite Disponível",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Crédito Disponível",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Títulos em atraso",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Total de títulos em atraso",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Títulos a vencer",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Títulos em aberto",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Data primeiro pedido",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Valor médio do pedido",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Data do pedido de maior valor",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Valor do maior pedido",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DottedLine(
                        dashLength: 1,
                        dashColor: Colors.white
                    ),
                  ),
                ),
                Text(
                  generatePrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}