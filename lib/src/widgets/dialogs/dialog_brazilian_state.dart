import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';

class DialogBrazilianState extends ConsumerWidget{
  final BrazilianState? selected;

  const DialogBrazilianState({
    super.key,
    this.selected
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final scheme = Theme.of(context).colorScheme;
   return AlertDialog(
     backgroundColor: scheme.surface,
     surfaceTintColor: Colors.transparent,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(16),
     ),
     titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
     contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

     title: Row(
       children: [
         const Expanded(
           child: Text(
             'Selecionar estado',
             style: TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.w600,
             ),
           ),
         ),
         IconButton(
           onPressed: () => Navigator.pop(context),
           icon: const Icon(Icons.close),
           visualDensity: VisualDensity.compact,
         ),
       ],
     ),

     content: SizedBox(
       width: double.maxFinite,
       child: ListView.separated(
         shrinkWrap: true,
         itemCount: BrazilianState.values.length,
         separatorBuilder: (_, __) => const SizedBox(height: 4),
         itemBuilder: (context, index) {
           final state = BrazilianState.values[index];
           final isSelected = state == selected;

           return InkWell(
             borderRadius: BorderRadius.circular(12),
             onTap: () => Navigator.pop(context, state),
             child: Container(
               padding: const EdgeInsets.symmetric(
                 horizontal: 12,
                 vertical: 10,
               ),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(
                   color: isSelected
                     ? scheme.primary
                     : scheme.outline,
                 ),
                 color: isSelected
                   ? scheme.primary.withValues(alpha: .08)
                   : scheme.surface,
               ),
               child: Row(
                 children: [
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                     decoration: BoxDecoration(
                       color: scheme.primary.withValues(alpha: 0.22),
                       borderRadius: BorderRadius.circular(4)
                     ),
                     child: Text(
                      state.name,
                       style: TextStyle(
                         color: scheme.primary,
                         fontWeight:  isSelected ? FontWeight.w600 : FontWeight.w500,
                       ),
                     ),
                   ),
                   SizedBox(width: 8),
                   Expanded(
                     child: Text(
                       state.fullName, // use a extensão
                       style: TextStyle(
                         fontSize: 14,
                         fontWeight:
                         isSelected ? FontWeight.w600 : FontWeight.w500,
                         color: scheme.onSurface,
                       ),
                     ),
                   ),
                   SizedBox(width: 8),
                   if (isSelected)
                     Icon(
                       Icons.check_circle,
                       size: 20,
                       color: scheme.primary,
                     ),
                 ],
               ),
             ),
           );
         },
       ),
     ),

     actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
     actions: [
       SizedBox(
         width: double.infinity,
         child: OutlinedButton(
           onPressed: () => Navigator.pop(context),
           child: const Text('Cancelar'),
         ),
       ),
     ],
   );
  }
}