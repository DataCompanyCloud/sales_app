import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvoicingOrderPage extends ConsumerWidget {
  final String title;

  const InvoicingOrderPage ({
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
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 48, left: 28, right: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Sumário de Pedido",
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        ListTile(
                          visualDensity: VisualDensity(vertical: 3),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(Icons.list_alt, color: Colors.black87),
                          ),
                          title: Text(
                            "Lista de pedidos",
                            style: TextStyle(
                                color: Colors.black87
                            ),
                          ),
                          trailing: Icon(Icons.chevron_right, color: Colors.black87),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    builder: (context, scrollController) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        width: 40,
                                                        height: 4,
                                                        margin: EdgeInsets.only(bottom: 12),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(2),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(top: 16)),
                                                    SizedBox(
                                                      height: 800,
                                                      child: ListView.builder(
                                                          controller: scrollController,
                                                          itemCount: 20,
                                                          itemBuilder: (context, i) {
                                                            return ListTile(
                                                              leading: Icon(Icons.image),
                                                              title: Text("Produto ${i+1}"),
                                                              subtitle: Text("Preço"),
                                                            );
                                                          }
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
                                            child: SafeArea(
                                                top: false,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 48,
                                                      child: Column(
                                                        children: [
                                                          Divider(color: Colors.black87, height: 8),
                                                          SizedBox(
                                                              width: double.infinity,
                                                              child: Padding(
                                                                padding: EdgeInsets.only(top: 12, left: 8, right: 8),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Total: ",
                                                                      style: TextStyle(
                                                                          fontSize: 18,
                                                                          color: Colors.black87,
                                                                          fontWeight: FontWeight.bold
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "R\$2.244,90",
                                                                      style: TextStyle(
                                                                        fontSize: 18,
                                                                        color: Colors.black87,
                                                                        //fontWeight: FontWeight.bold
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                            );
                          },
                        ),
                      ],
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  child: Card(
                    color: Color(0xFF0081F5),
                    elevation: 3,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ID de pedido",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            "#103",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: 350),
                      child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    context.push('/order/create_order/invoicing_order/finish_order');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 3,
                                      padding: EdgeInsets.symmetric(horizontal: 120, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30)
                                      ),
                                      backgroundColor: Color(0xFF0081F5),
                                      foregroundColor: Colors.white
                                  ),
                                  child: Text(
                                    "Confirmar",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),
                            ),
                          ]
                      ),
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}