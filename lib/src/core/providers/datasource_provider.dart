import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/objectbox.g.dart';

final datasourceProvider = FutureProvider<Store>((ref) async {
  final store = await openStore();
  return store;
});
