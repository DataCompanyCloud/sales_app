import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Masks {
  static final cep = MaskTextInputFormatter(
    mask: '#####-###',
    filter: { '#': RegExp(r'[0-9]') },
  );

  static final cpf = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: { "#": RegExp(r'[0-9]') },
  );

  static final phone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: { "#": RegExp(r'[0-9]') },
  );

  // Email: sem máscara, apenas restrições
  static final emailInputFormatters = <TextInputFormatter>[
    FilteringTextInputFormatter.deny(RegExp(r'\s')), // bloqueia espaços
  ];
}