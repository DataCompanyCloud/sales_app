import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTypePage extends ConsumerWidget {

  const UserTypePage ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// TODO Terminar a página de tipo de usuário
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 72),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.black),
                Text(
                  "DataCompany",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Text("Conecte-se"),
            Text("Descrição"),
            SizedBox(
              width: 200,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  backgroundColor: Color(0xFF0081F5),
                  foregroundColor: Colors.white
                ),
                child: Text("Login")
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 32,
              endIndent: 32,
            ),
            SizedBox(
              width: 200,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  backgroundColor: Color(0xFF0081F5),
                  foregroundColor: Colors.white
                ),
                icon: Icon(Icons.circle, color: Colors.white),
                label: Text(
                  "Google"
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}