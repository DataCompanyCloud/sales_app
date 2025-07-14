import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/schedule/presentation/controllers/agenda_controller.dart';

final agendaViewModelProvider = ChangeNotifierProvider((ref) {
  return AgendaViewModel();
});

final agendaIndexProvider = StateProvider<int>((ref) => 4);