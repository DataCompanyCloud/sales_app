import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/product_fiscal.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/product_tax_calculator.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/product_tax_result.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/tax_context.dart';

part 'sales_order_product.freezed.dart';
part 'sales_order_product.g.dart';

@freezed
abstract class SalesOrderProduct with _$SalesOrderProduct {
  const SalesOrderProduct._();

  const factory SalesOrderProduct.raw({
    required String productUuId,
    required int productId,
    required String productCode,
    required String productName,
    required double quantity,
    required Money unitPrice,
    ImageEntity? images,
    int? orderId,
    // @Default('UN') String unitOfMeasure, // Type
    @Default(Money.raw(amount: 0)) Money discountAmount,
    required ProductFiscal fiscal,
    ProductTaxResult? taxResult
  }) = _SalesOrderProduct;


  factory SalesOrderProduct({
    required String productUuId,
    required int productId,
    required String productCode,
    required String productName,
    required double quantity,
    required Money unitPrice,
    ImageEntity? images,
    int? orderId,
    Money? discountAmount,
    required ProductFiscal fiscal,
    ProductTaxResult? taxResult    // salvo no banco DEPOIS do fechamento
  }) {

    //TODO fazer as validações
    if (productName.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Nome do produto não pode ser vazio");
    }

    if (quantity.isNegative) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Quantidade não pode ser um valor negativo");
    }

    return SalesOrderProduct.raw(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      images: images,
      orderId: orderId,
      discountAmount: discountAmount ?? const Money.raw(amount: 0),
      fiscal: fiscal,
      taxResult: taxResult
    );
  }

  factory SalesOrderProduct.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderProductFromJson(json);

  Money get totalPrice => unitPrice.multiply(quantity);


  /// Cria uma instância de [ProductTaxCalculator] para este item.
  ///
  /// - Não realiza cálculos diretamente.
  /// - Apenas prepara o “calculador fiscal” combinando:
  ///     • os dados fiscais fixos do produto (ProductFiscal)
  ///     • o contexto tributário da operação (TaxContext)
  ///     • o valor total do item (unitPrice × quantity)
  ///
  /// Este método é apenas um *helper* de conveniência:
  ///   → A entidade SalesOrderProduct **não** deve conter regras fiscais.
  ///   → O cálculo real acontece apenas dentro de ProductTaxCalculator.
  ///
  /// O objetivo é: evitar duplicação de código ao instanciar o calculador e permitir que impostos sejam recalculados sempre que o contexto (empresa, cliente, CFOP, UF, regime, etc.) mudar
  ///
  /// O [ProductTaxCalculator] criado aqui é temporário e não é salvo no banco.
  SalesOrderProduct calculator(TaxContext context) {
    final calc = ProductTaxCalculator(
      fiscal: fiscal,
      context: context,
      baseCalc: unitPrice.multiply(quantity),
    );

    return copyWith(
      taxResult: calc.buildResult()
    );
  }
}