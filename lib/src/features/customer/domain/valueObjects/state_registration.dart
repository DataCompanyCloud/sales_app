import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';

part 'state_registration.freezed.dart';
part 'state_registration.g.dart';

/// Inscrição estadual
@freezed
abstract class StateRegistration with _$StateRegistration {
  const StateRegistration._();

  const factory StateRegistration.raw({
    required BrazilianState uf,
    @Default('') String number,
    @Default(false) bool isExempt,
  }) = _StateRegistration;

  /// Construtor com validação e normalização
  factory StateRegistration({
    required BrazilianState uf,
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

final Map<BrazilianState, _IESpec> _ieSpecs = {
  BrazilianState.AC: _IESpec(13, (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}/${s.substring(8,11)}-${s.substring(11)}'),
  BrazilianState.AL: _IESpec(9,  (s) => s), // sem separadores
  BrazilianState.AM: _IESpec(9,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}-${s.substring(8)}'),
  BrazilianState.AP: _IESpec(9,  (s) => s),
  BrazilianState.BA: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,8)}-${s.substring(8)}'),
  BrazilianState.CE: _IESpec(9,  (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  BrazilianState.DF: _IESpec(13, (s) => '${s.substring(0,11)}-${s.substring(11)}'),
  BrazilianState.ES: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,8)}-${s.substring(8)}'),
  BrazilianState.GO: _IESpec(9,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}-${s.substring(8)}'),
  BrazilianState.MA: _IESpec(9,  (s) => s),
  BrazilianState.MG: _IESpec(13, (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,9)}/${s.substring(9)}'),
  BrazilianState.MS: _IESpec(9,  (s) => s),
  BrazilianState.MT: _IESpec(9,  (s) => s),
  BrazilianState.PA: _IESpec(9,  (s) => '${s.substring(0,2)}-${s.substring(2,8)}-${s.substring(8)}'),
  BrazilianState.PB: _IESpec(9,  (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  BrazilianState.PE: _IESpec(14, (s) => '${s.substring(0,2)}.${s.substring(2,3)}.${s.substring(3,6)}.${s.substring(6,13)}-${s.substring(13)}'),
  BrazilianState.PI: _IESpec(9,  (s) => s),
  BrazilianState.PR: _IESpec(10, (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  BrazilianState.RJ: _IESpec(8,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,7)}-${s.substring(7)}'),
  BrazilianState.RN: _IESpec(9,  (s) => '${s.substring(0,2)}.${s.substring(2,5)}.${s.substring(5,8)}-${s.substring(8)}'),
  BrazilianState.RO: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,8)}-${s.substring(8)}'),
  BrazilianState.RR: _IESpec(9,  (s) => '${s.substring(0,8)}-${s.substring(8)}'),
  BrazilianState.RS: _IESpec(10, (s) => '${s.substring(0,3)}-${s.substring(3)}'),
  BrazilianState.SC: _IESpec(9,  (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6)}'),
  BrazilianState.SE: _IESpec(10, (s) => '${s.substring(0,9)}-${s.substring(9)}'),
  BrazilianState.SP: _IESpec(12, (s) => '${s.substring(0,3)}.${s.substring(3,6)}.${s.substring(6,9)}.${s.substring(9)}'),
  BrazilianState.TO: _IESpec(11, (s) => s),
};

class _IESpec {
  final int len;
  final String Function(String) fmt;
  const _IESpec(this.len, this.fmt);
}