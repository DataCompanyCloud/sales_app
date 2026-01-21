import 'dart:async';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';

class StorageFilter {
  final int start;
  final int limit;
  final String? q;

  const StorageFilter({
    this.start = 0,
    this.limit = 20,
    this.q,
  });

  StorageFilter copyWith ({
    int? start,
    // int? limit,
    String? q,
  }) {
    return StorageFilter(
      start: start ?? this.start,
      limit: limit,
      q: q ?? this.q,
    );
  }
}

abstract class StorageRepository {
  /// Busca todos os estoques
  Future<List<Storage>> fetchAll(StorageFilter filter);
  /// Busca um estoque pelo ID
  Future<Storage> fetchById(int storageId);
  /// Salva vários estoques
  Future<void> saveAll(List<Storage> storages);
  /// Salva um estoque
  Future<Storage> save(Storage storage);
  /// Remove um estoque
  Future<void> delete(Storage storage);
  /// Remove TODOS os estoques
  Future<void> deleteAll();
  /// Retorna a quantidade total de estoques no banco
  Future<int> count();
}