import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_filter.freezed.dart';

enum CustomerStatusFilter {
  all,           // Todos
  active,        // Ativos
  blocked,       // Bloqueados
  synced,        // Sincronizados
  notSynced,     // Não Sincronizados
}

// TODO adicionar opção de filtrar por endereço
@freezed
abstract class CustomerFilter with _$CustomerFilter  {
  const factory CustomerFilter({
    String? customerCode,
    String? name,
    String? phone,
    String? document, // CPF ou CNPJ
    String? email,
    @Default(0) int page,
    @Default(30) int limit
  }) = _CustomerFilter;

  const CustomerFilter._();

  /// Retorna true se **qualquer** um dos filtros obrigatórios estiver não-nulo e não-vazio
  bool get hasActiveFilters {
    return [
      customerCode,
      name,
      phone,
      document,
      email,
    ].any((s) => s?.isNotEmpty == true);
  }

  /// Quantos dos filtros (customerCode, name, phone, document, email) estão efetivamente preenchidos
  int get activeFiltersCount {
    return [
      customerCode,
      name,
      phone,
      document,
      email,
    ].where((s) => s?.isNotEmpty == true).length;
  }
}

