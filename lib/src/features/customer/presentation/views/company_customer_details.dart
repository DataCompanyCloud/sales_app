import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/company_customer.dart';

class CompanyCustomerDetails extends ConsumerWidget {
  final CompanyCustomer customer;

  const CompanyCustomerDetails({
    super.key,
    required this.customer
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(customer.customerCode),
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back_ios_new, size: 22)
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextButton(
                  onPressed: () {

                  },
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  )
              ),
            )
          ],
          backgroundColor: Color(0xFF0081F5),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 75),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                          color: Colors.grey.shade400,
                          width: 3
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: customer.isActive
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        Icons.apartment,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 16),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "DETALHES DO CLIENTE",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Column(
                                children: [
                                  Divider(
                                    thickness: 1.5,
                                    indent: 15,
                                    endIndent: 15,
                                    color: Colors.grey.shade200,
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("Razão Social: "),
                                    subtitle: Text(
                                      customer.legalName,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Editar",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFF0081F5),
                                              fontSize: 16,
                                              color: Color(0xFF0081F5)
                                          ),
                                        )
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("Nome Fantasia: "),
                                    subtitle: Text(
                                      customer.tradeName,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Editar",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFF0081F5),
                                              fontSize: 16,
                                              color: Color(0xFF0081F5)
                                          ),
                                        )
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("CNPJ: "),
                                    subtitle: Text(
                                      customer.cnpj.formatted,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Editar",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFF0081F5),
                                              fontSize: 16,
                                              color: Color(0xFF0081F5)
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "ENDEREÇO",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              indent: 15,
                              endIndent: 15,
                              color: Colors.grey.shade200,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Column(
                                children: [
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("Estado: "),
                                    subtitle: Text(
                                      customer.address.state,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Editar",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFF0081F5),
                                              fontSize: 16,
                                              color: Color(0xFF0081F5)
                                          ),
                                        )
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("Cidade: "),
                                    subtitle: Text(
                                      customer.address.city,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Editar",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFF0081F5),
                                              fontSize: 16,
                                              color: Color(0xFF0081F5)
                                          ),
                                        )
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("CEP: "),
                                    subtitle: Text(
                                      customer.address.cep.formatted,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Editar",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFF0081F5),
                                              fontSize: 16,
                                              color: Color(0xFF0081F5)
                                          ),
                                        )
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("Rua: "),
                                    subtitle: Text(
                                      customer.address.street,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Editar",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFF0081F5),
                                              fontSize: 16,
                                              color: Color(0xFF0081F5)
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "CONTATO",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              indent: 15,
                              endIndent: 15,
                              color: Colors.grey.shade200,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Column(
                                children: [
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("Email: "),
                                    subtitle: Text(
                                      customer.email.value,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: 0.2),
                                    title: Text("Telefone: "),
                                    subtitle: Text(
                                      customer.phones.first.value,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {

                                            },
                                            icon: Icon(Icons.phone, size: 24)
                                        ),
                                        TextButton(
                                            onPressed: () {

                                            },
                                            child: Text(
                                              "Editar",
                                              style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  decorationColor: Color(0xFF0081F5),
                                                  fontSize: 16,
                                                  color: Color(0xFF0081F5)
                                              ),
                                            )
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
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

}