import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'uf.dart';

part 'state_registration.freezed.dart';
part 'state_registration.g.dart';

/// Inscrição estadual
@freezed
abstract class StateRegistration with _$StateRegistration {
  const StateRegistration._();

  const factory StateRegistration.raw({
    required UF uf,
    @Default('') String number,
    @Default(false) bool isExempt,
  }) = _StateRegistration;

  /// Construtor com validação e normalização
  factory StateRegistration({
    required UF uf,
    String? number,
    bool isExempt = false,
  }) {
    final digits = _onlyDigits(number ?? '');

    // isento → não deve ter número
    if (isExempt && digits.isNotEmpty) {
      throw ArgumentError('Cliente ISENTO não deve possuir número de IE.');
    }

    if (!isExempt && digits.isEmpty) {
      throw ArgumentError('Inscrição Estadual obrigatória para não isento.');
    }

    return StateRegistration.raw(uf: uf, number: digits, isExempt: isExempt);
  }

  factory StateRegistration.fromJson(Map<String, dynamic> json) =>
      _$StateRegistrationFromJson(json);

  static String _onlyDigits(String s) => s.replaceAll(RegExp(r'\D'), '');

  String format() {
    if (isExempt) return 'ISENTO';
    final d = _onlyDigits(number);

    final spec = _ieSpecs[uf];
    if (spec == null) return d; // fallback
    if (d.length != spec.len) {
      throw AppException(
        AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
        'IE inválida para ${uf.name}: esperados ${spec.len} dígitos, recebido ${d.length}.',
      );
    }
    return spec.fmt(d);
  }
}

final Map<UF, _IESpec> _ieSpecs = {
  UF.AC: _IESpec(13, (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}/${s.substring(8,11)}-${s.substring(11)}'),
  UF.AL: _IESpec(9,  (s) => s), // sem separadores
  UF.AM: _IESpec(9,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}-${s.substring(8)}'),
  UF.AP: _IESpec(9,  (s) => s),
  UF.BA: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,8)}-${s.substring(8)}'),
  UF.CE: _IESpec(9,  (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  UF.DF: _IESpec(13, (s) => '${s.substring(0,11)}-${s.substring(11)}'),
  UF.ES: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,8)}-${s.substring(8)}'),
  UF.GO: _IESpec(9,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}-${s.substring(8)}'),
  UF.MA: _IESpec(9,  (s) => s),
  UF.MG: _IESpec(13, (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,9)}/${s.substring(9)}'),
  UF.MS: _IESpec(9,  (s) => s),
  UF.MT: _IESpec(9,  (s) => s),
  UF.PA: _IESpec(9,  (s) => '${s.substring(0,2)}-${s.substring(2,8)}-${s.substring(8)}'),
  UF.PB: _IESpec(9,  (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  UF.PE: _IESpec(14, (s) => '${s.substring(0,2)}.${s.substring(2,3)}.${s.substring(3,6)}.${s.substring(6,13)}-${s.substring(13)}'),
  UF.PI: _IESpec(9,  (s) => s),
  UF.PR: _IESpec(10, (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  UF.RJ: _IESpec(8,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,7)}-${s.substring(7)}'),
  UF.RN: _IESpec(9,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}-${s.substring(8)}'),
  UF.RO: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,8)}-${s.substring(8)}'),
  UF.RR: _IESpec(9,  (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  UF.RS: _IESpec(10, (s) => '${s.substring(0,3)}-${s.substring(3)}'),
  UF.SC: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6)}'),
  UF.SE: _IESpec(10, (s) => '${s.substring(0,9)}-${s.substring(9)}'),
  UF.SP: _IESpec(12, (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,9)}.${s.substring(9)}'),
  UF.TO: _IESpec(11, (s) => s),
};

class _IESpec {
  final int len;
  final String Function(String) fmt;
  const _IESpec(this.len, this.fmt);
}