import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionsDescriptionDialog extends ConsumerWidget {
  final String title;
  final String description;
  final IconData icon;

  const OptionsDescriptionDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        description,
        style: TextStyle(
          fontSize: 16
        ),
      ),
    );
  }
}