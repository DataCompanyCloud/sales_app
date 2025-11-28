import 'dart:convert';

import 'package:sales_app/src/features/salesOrder/data/utils/tax_icms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaxRepositoryImpl {
  static const _taxICMSKey = 'tax_icms';

  Future<void> save(TaxIcms tax) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tax.toJson());
    await prefs.setString(_taxICMSKey, jsonString);
  }

  Future<TaxIcms> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_taxICMSKey);

    if (jsonString == null) {
      throw Exception('Nenhuma tabela ICMS encontrada');
    }

    final Map<String, dynamic> data = jsonDecode(jsonString);
    return TaxIcms.fromJson(data);
  }

  Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_taxICMSKey);
  }
}
