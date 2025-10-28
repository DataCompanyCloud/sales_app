import 'package:sales_app/src/features/storage/domain/entities/storage.dart';

abstract class StorageRepository {
  /// Busca todos os estoques
  Future<List<Storage>> fetchAll({String? search});
  /// Busca um estoque pelo ID
  Future<Storage> fetchById(int storageId);
  /// Salva vários estoques
  Future<void> saveAll(List<Storage> storages);
  /// Salva um estoque
  Future<Storage> save(Storage storage);
  /// Atualiza os dados de um estoque sem apagar o histórico localmente
  // Future<Storage> update(Storage storage);
  /// Remove um estoque
  Future<void> delete(Storage storage);
  /// Remove TODOS os estoques
  Future<void> deleteAll();
  /// Retorna a quantidade total de estoques no banco
  Future<int> count();
}