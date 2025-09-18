import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CompanyCustomerDetails extends ConsumerWidget {
  final CompanyCustomer customer;

  const CompanyCustomerDetails({
    super.key,
    required this.customer
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.customerCode ?? "--"),
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
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final controller = ref.read(customerDetailsControllerProvider(customer.customerId));
          if (!controller.isLoading) {
            final _ = ref.refresh(customerDetailsControllerProvider(customer.customerId));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: customer.isActive
                          ? Colors.green.shade800
                          : Colors.red.shade800,
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
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 16),
                    child: Column(
                      children: [
                        Card(
                          color: colorScheme.surface,
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
                                      color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1.5,
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade500,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Column(
                                  children: [
                                    ListTile(
                                      visualDensity: VisualDensity(vertical: 0.2),
                                      title: Text("Razão Social"),
                                      subtitle: Text(
                                        customer.legalName ?? "--",
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
                                      title: Text("Nome Fantasia"),
                                      subtitle: Text(
                                        customer.tradeName ?? "--",
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
                                        customer.cnpj?.formatted ?? '',
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
                                      title: Text("Setor"),
                                      subtitle: Text(
                                        customer.businessSector ?? "--"
                                        ,
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
                          color: colorScheme.surface,
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
                                    "FINANCEIRO",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                   ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1.5,
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade500,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Column(
                                  children: [
                                    ListTile(
                                      visualDensity: VisualDensity(vertical: 0.2),
                                      title: Text(
                                        "IE (${customer.stateRegistration.uf.name})",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      subtitle: Text(
                                            () {
                                          try {
                                            return customer.stateRegistration.isExempt
                                                ? "ISENTO"
                                                : customer.stateRegistration.format();
                                          } catch (e) {
                                            return e.toString();
                                          }
                                        }()
                                        ,
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
                                      title: Text(
                                        "Tipo de Tributação",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      subtitle: Text(
                                        customer.taxRegime?.label ?? "--"
                                        ,
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
                                      title: Text(
                                        "Forma de pagamento",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 12),
                                          Text.rich(
                                            TextSpan(
                                              children: customer.paymentMethods.map((p) {
                                                return WidgetSpan(
                                                  alignment: PlaceholderAlignment.middle,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 4, bottom: 4),
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: colorScheme.surface,
                                                        border: Border.all(color: colorScheme.onSurface, width: 1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Text(
                                                        p.label,
                                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList()
                                            )
                                          ),
                                        ],
                                      ) ,

                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(vertical: 0.2),
                                      title: Text(
                                        "Limite de crédito",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      subtitle: customer.creditLimit == null
                                        ? Text(
                                           "Sem Limite",
                                          style: TextStyle(
                                            fontSize: 15
                                          ),
                                        )
                                        : Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 12),
                                            Container(
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: colorScheme.onPrimary,
                                                borderRadius: BorderRadius.circular(42),
                                              ),
                                              clipBehavior: Clip.hardEdge, // garante que o filho respeite o raio
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: FractionallySizedBox(
                                                  widthFactor: (customer.creditLimit?.available.ratioTo(customer.creditLimit!.maximum)),
                                                  child: Container(
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: colorScheme.primary,
                                                      borderRadius: BorderRadius.circular(42),
                                                      // geralmente NÃO precisa de borda interna aqui
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "R\$ ${customer.creditLimit?.available.decimalValue.toString() ?? "--"}" ,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: colorScheme.primary,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    Text(
                                                      "Disponível" ,
                                                      style: TextStyle(
                                                        fontSize: 15
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      //TODO melhorar isso aqui: retirar o !
                                                      "R\$ ${( customer.creditLimit!.maximum.minus(customer.creditLimit!.available)).decimalValue.toString()}" ,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    Text(
                                                      "Utilizado" ,
                                                      style: TextStyle(
                                                        fontSize: 15
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Card(
                          color: colorScheme.surface,
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
                                      color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1.5,
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade500,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Column(
                                  children: [
                                    ListTile(
                                      visualDensity: VisualDensity(vertical: 0.2),
                                      title: Text("Estado: "),
                                      subtitle: Text(
                                        customer.address?.state ?? '',
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
                                        customer.address?.city ?? '',
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
                                        customer.address?.cep?.value ?? '',
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
                                        customer.address?.street ?? '',
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
                        customer.primaryContact != null
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Card(
                            color: colorScheme.surface,
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
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1.5,
                                  indent: 15,
                                  endIndent: 15,
                                  color: Colors.grey.shade500,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        visualDensity: VisualDensity(vertical: 0.2),
                                        title: Text("Nome: "),
                                        subtitle: Text(
                                          customer.primaryContact?.name ?? '',
                                          style: TextStyle(
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        visualDensity: VisualDensity(vertical: 0.2),
                                        title: Text("Email: "),
                                        subtitle: Text(
                                          customer.primaryContact?.email?.value ?? '',
                                          style: TextStyle(
                                            fontSize: 15
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        visualDensity: VisualDensity(vertical: 0.2),
                                        title: Text("Telefone: "),
                                        subtitle: Text(
                                          customer.primaryContact?.phone?.value ?? '',
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
                                              icon: Icon(
                                                customer.primaryContact?.phone?.type == PhoneType.whatsapp
                                                  ? Icons.chat
                                                  : Icons.phone, size: 24
                                              )
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
                                                  ),
                          )
                          : SizedBox()
                        ,
                        customer.notes != null
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Card(
                            color: colorScheme.surface,
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
                                      "DESCRIÇÃO",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1.5,
                                  indent: 15,
                                  endIndent: 15,
                                  color: Colors.grey.shade500,
                                ),
                                Column(
                                  children: [
                                    ListTile(
                                      visualDensity: VisualDensity(vertical: 0.2),
                                      subtitle: Text(
                                        customer.notes ?? '--',
                                        style: TextStyle(
                                          fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                                                  ),
                          )
                          : SizedBox()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

}