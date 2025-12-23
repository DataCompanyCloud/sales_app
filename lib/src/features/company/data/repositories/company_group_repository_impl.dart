import 'package:sales_app/src/features/company/data/models/company_group_model.dart';
import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/company/data/models/company_model.dart';
import 'package:sales_app/src/features/company/domain/entities/company_group.dart';
import 'package:sales_app/src/features/company/domain/repositories/company_group_repository.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';


class CompanyGroupRepositoryImpl extends CompanyGroupRepository {
  final Store store;

  CompanyGroupRepositoryImpl(this.store);

  @override
  Future<List<CompanyGroup>> fetchAll(CompanyGroupFilter filter)  async {
    final box = store.box<CompanyGroupModel>();
    Condition<CompanyGroupModel>? cond;

    // Texto
    // final raw = filter.q?.trim();
    // if (raw != null && raw.isNotEmpty) {
    //   cond = CompanyGroupModel_..contains(raw, caseSensitive: false) | SalesOrderModel_.orderCode.contains(raw, caseSensitive: false);
    // }
    //
    // if (filter.status != null) {
    //   final statusCond = SalesOrderModel_.status.equals(filter.status!.index);
    //   cond = (cond == null) ? statusCond : (cond & statusCond);
    // }


    // final qb = (cond == null) ? box.query() : box.query(cond);
    final q = box.query(cond).build();

    try {
      final models = await q.findAsync();
      return models.map((m) => m.toEntity()).toList();
    } finally {
      q.close();
    }
  }

  @override
  Future<CompanyGroup> fetchById(int groupId) async {
    try {
      final companyGroupBox = store.box<CompanyGroupModel>();

      final model = await companyGroupBox.getAsync(groupId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado");
      }

      return model.toEntity();
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

  @override
  Future<void> saveAll(List<CompanyGroup> groups) async {
    final companyGroupBox = store.box<CompanyGroupModel>();
    final companyBox = store.box<CompanyModel>();
    final addressBox = store.box<AddressModel>();

    store.runInTransaction(TxMode.write, () {
      for (final group in groups) {
        final existingQ = companyGroupBox.query(CompanyGroupModel_.groupId.equals(group.groupId)).build();
        final existing  = existingQ.findFirst();
        existingQ.close();

        final newModel = group.toModel();

        newModel.id = existing?.id ?? 0;
        if (existing != null) {
          existing.deleteRecursively(
            companyGroupBox: companyGroupBox,
            companyBox: companyBox,
            addressBox: addressBox
          );
        }

        companyGroupBox.put(newModel);
      }
    });
  }

  @override
  Future<CompanyGroup> save(CompanyGroup group) async {
    final companyGroupBox = store.box<CompanyGroupModel>();
    final companyBox = store.box<CompanyModel>();
    final addressBox = store.box<AddressModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existingQ = companyGroupBox.query(CompanyGroupModel_.groupId.equals(group.groupId)).build();
      final existing  = existingQ.findFirst();
      existingQ.close();

      final newModel = group.toModel();

      newModel.id = existing?.id ?? 0;
      if (existing != null) {
        existing.deleteRecursively(
          companyGroupBox: companyGroupBox,
          companyBox: companyBox,
          addressBox: addressBox
        );
      }

      companyGroupBox.put(newModel);
    });

    final saved = await companyGroupBox.getAsync(id);
    if (saved == null) {
      throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado após sua inserção");
    }

    return saved.toEntity();
  }

  @override
  Future<void> delete(CompanyGroup company) async {
    final companyGroupBox = store.box<CompanyGroupModel>();
    final companyBox = store.box<CompanyModel>();
    final addressBox = store.box<AddressModel>();

    store.runInTransaction(TxMode.write, () {
      final existingQ = companyGroupBox.query(CompanyGroupModel_.groupId.equals(company.groupId)).build();
      final model = existingQ.findFirst();
      existingQ.close();

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado");
      }

      model.deleteRecursively(
        companyGroupBox: companyGroupBox,
        companyBox: companyBox,
        addressBox: addressBox
      );
    });
  }

  @override
  Future<void> deleteAll() async {
    final companyGroupBox = store.box<CompanyGroupModel>();
    final companyBox = store.box<CompanyModel>();
    final addressBox = store.box<AddressModel>();

    store.runInTransaction(TxMode.write, () {
      final allGroups = companyGroupBox.getAll();

      for (final model in allGroups) {

        model.deleteRecursively(
          companyGroupBox: companyGroupBox,
          companyBox: companyBox,
          addressBox: addressBox
        );
      }
    });
  }

  @override
  Future<int> count() {
    final companyGroupBox = store.box<CompanyGroupModel>();
    return Future.value(companyGroupBox.count());
  }
}