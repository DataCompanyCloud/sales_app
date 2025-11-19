//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
// import 'package:sales_app/src/features/customer/providers.dart';
// import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
// import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
// import 'package:sales_app/src/features/salesOrder/providers.dart';
// import 'package:skeletonizer/skeletonizer.dart';
//
// class  {
//
// }
//
//
// class SalesOrderCreateCustomerScreen extends ConsumerStatefulWidget {
//   final SalesOrder?  order;
//
//   const SalesOrderCreateCustomerScreen({
//     super.key,
//     required this.order,
//   });
//
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => SalesOrderCustomerSectionState();
// }
//
// class SalesOrderCustomerSectionState extends ConsumerState<SalesOrderCreateCustomerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final scheme = theme.colorScheme;
//     final salesOrder = widget.order;
//     final salesOrderCustomer = salesOrder?.customer;
//
//
//     if (salesOrderCustomer == null || salesOrder == null) {
//       return Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             InkWell(
//               onTap: _selectCustomer,
//               child: Container(
//                 padding: EdgeInsets.all(8),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: scheme.surface,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: scheme.outline, width: 2)
//                 ),
//                 child: SizedBox(
//                   height: 48,
//                   child: Center(
//                     child: Text(
//                       "Selecionar Cliente",
//                       style: TextStyle(
//                           fontSize: 18
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     final controller = ref.watch(customerDetailsControllerProvider(salesOrderCustomer.customerId));
//
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: _selectCustomer,
//             child: Container(
//                 padding: EdgeInsets.all(8),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: scheme.surface,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: scheme.outline, width: 2)
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                           color: scheme.onPrimary,
//                           borderRadius: BorderRadius.circular(40)
//                       ),
//                       child: Icon(
//                           salesOrderCustomer.cnpj != null
//                               ? Icons.apartment
//                               : Icons.person
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                               salesOrderCustomer.customerName ?? "--"
//                           ),
//                           Text(
//                             salesOrderCustomer.customerCode ?? "--",
//                             style: TextStyle(
//                                 fontSize: 12
//                             ),
//                           ),
//                           Text(
//                             salesOrderCustomer.cnpj?.formatted ?? salesOrderCustomer.cpf?.formatted ?? "--",
//                             style: TextStyle(
//                                 fontSize: 12
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Icon(
//                       Icons.menu,
//                     )
//                   ],
//                 )
//             ),
//           ),
//           SizedBox(height: 8),
//           controller.when(
//             error: (error, stack) => Text("error"),
//             loading: () => Skeletonizer(
//                 child: child
//             ),
//             data: (customer) {
//               final addresses = customer.addresses;
//
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Endereços:"),
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       side: BorderSide(width: 2, color: scheme.outline),
//                     ),
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: addresses.length,
//                       separatorBuilder: (context, index) => Divider(
//                         height: 2,
//                         thickness: 2,
//                         color: scheme.outline,
//                       ),
//                       itemBuilder: (context, index) {
//                         final address = addresses[index];
//                         return RadioListTile<Address>(
//                           onChanged: (value) {
//                             if (value == null) return;
//                             ref.read(salesOrderCreateControllerProvider(salesOrder.orderId).notifier)
//                                 .saveEdits(salesOrder.updateCustomerAddress(value));
//                           },
//                           value: address,
//                           groupValue: salesOrderCustomer.address ?? customer.primaryAddress,
//                           tileColor: scheme.surface,
//                           title: Text(address.formatted),
//                           subtitle: Text(address.type.label),
//                           splashRadius: 10,
//                           dense: true,
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//                         );
//                       },
//                     ),
//                   ),
//                   customer.contacts.isEmpty
//                       ? SizedBox()
//                       : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 8),
//                       Text("Contatos:"),
//                       Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                           side: BorderSide(width: 2, color: scheme.outline),
//                         ),
//                         child: ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: customer.contacts.length,
//                           separatorBuilder: (context, index) => Divider(
//                             height: 2,
//                             thickness: 2,
//                             color: scheme.outline,
//                           ),
//                           itemBuilder: (context, index) {
//                             final contact = customer.contacts[index];
//
//                             return RadioListTile<ContactInfo>(
//                               onChanged: (value) {
//                                 if (value == null) return;
//                                 final updated = salesOrder.updateCustomerContact(value);
//                                 ref.read(salesOrderCreateControllerProvider(salesOrder.orderId).notifier)
//                                     .saveEdits(updated)
//                                 ;
//                               },
//                               value: contact,
//                               groupValue: salesOrderCustomer.contactInfo,
//                               tileColor: scheme.surface,
//                               title: Text(contact.name),
//                               subtitle: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(contact.phone?.value.toString() ?? "--"),
//                                   Text(contact.email?.value.toString() ?? "--"),
//                                 ],
//                               ),
//                               splashRadius: 10,
//                               dense: true,
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
//
//   Future<void> _selectCustomer() async {
//     final order = widget.order;
//     final selected = await context.pushNamed<Customer?>(OrderRouter.select_customer.name);
//
//     if (selected == null) return;
//
//     if (order != null) {
//       final newOrder = order.updateCustomer(selected);
//
//       await ref
//           .read(salesOrderCreateControllerProvider(order.orderId).notifier)
//           .saveEdits(newOrder);
//       return;
//     }
//
//     final newOrder = await ref
//         .read(salesOrderCreateControllerProvider(order?.orderId).notifier)
//         .createNewOrder(customer: selected);
//
//     if (!context.mounted) return;
//     context.goNamed(OrderRouter.create.name, queryParameters: {"orderId": newOrder.orderId.toString()});
//   }
// }
