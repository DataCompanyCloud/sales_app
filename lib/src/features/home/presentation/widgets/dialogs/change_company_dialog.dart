import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangeCompanyDialog extends ConsumerWidget {
  const ChangeCompanyDialog ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      title: Stack(
        children: [
          Positioned(
            left: 208,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.close,

                color: Colors.white,
              )
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 42),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Deseja mudar de empresa?",
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
              SizedBox(height: 6),
              ListTile(
                leading: Icon(Icons.check_box),
                title: Text("Empresa A"),
                onTap: () {
                  context.pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Empresa B"),
                onTap: () {
                  context.pop();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 42),
                child: ListTile(
                  leading: Icon(Icons.check_box_outline_blank),
                  title: Text("Empresa C"),
                  onTap: () {
                    context.pop();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}