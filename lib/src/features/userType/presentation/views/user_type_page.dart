import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTypePage extends ConsumerWidget {

  const UserTypePage ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 12),
              child: Text(
                "Conecte-se",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0081F5)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 58),
              child: Text(
                "Já é um cliente DataCompany?",
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
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
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 32,
                      endIndent: 12,
                    )
                  ),
                  Text(
                    "Ou",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 12,
                      endIndent: 32,
                    )
                  ),
                ],
              ),
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
                  "Google",
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}