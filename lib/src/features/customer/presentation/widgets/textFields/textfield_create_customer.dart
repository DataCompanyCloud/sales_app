import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TextFieldCreateCustomer extends ConsumerWidget{
  final TextEditingController controller;
  final IconData? icon;
  final String? hintText;

  const TextFieldCreateCustomer({
    super.key,
    required this.controller,
    this.hintText,
    this.icon
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        prefixIcon: icon == null ? null : Icon(icon),
        labelText: hintText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
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
    );
  }
}


