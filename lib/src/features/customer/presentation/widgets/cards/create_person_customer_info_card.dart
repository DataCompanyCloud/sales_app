import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePersonCustomerInfoCard extends ConsumerWidget {

  const CreatePersonCustomerInfoCard ({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 6, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Dados do Cliente",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_rounded),
                hintText: "Nome Completo",
                hintStyle: TextStyle(
                  color: colorScheme.onPrimary
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFF0081F5),
                    width: 2
                  )
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: TextField(
              keyboardType: TextInputType.number,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.numbers_rounded),
                hintText: "CPF",
                hintStyle: TextStyle(
                  color: colorScheme.onPrimary
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFF0081F5),
                    width: 2
                  )
                )
              ),
            ),
          ),
        ],
      )
    );
  }
}