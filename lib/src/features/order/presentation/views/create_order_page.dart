import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateOrderPage extends ConsumerWidget {
  final String title;

  const CreateOrderPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0081F5),
          foregroundColor: Colors.white,
          title: Text(title),
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back_ios_new, size: 22)
          ),
          actions: [
            IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.notifications)
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
                context.push('/order/create_order/invoicing_order');
              },
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 48, left: 28, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF0081F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.person_add, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 4,
                          color: Color(0xFF0081F5),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF0081F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.add_business, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 4,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.attach_money_sharp, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 4,
                              color: Colors.grey.shade500,
                            ),
                          )
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                Icons.check, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(
                          color: Colors.grey.shade400,
                          height: 64,
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {

                              },
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
                        Padding(
                          padding: EdgeInsets.only(top: 32),
                          child: Column(
                            children: [
                              TextField(
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    hintText: "Qtd. Produtos",
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2
                                        )
                                    )
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 18)),
                              TextField(
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Text(
                                        "R\$",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 0,
                                      minHeight: 0,
                                    ),
                                    hintText: "0,00",
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2
                                        )
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}