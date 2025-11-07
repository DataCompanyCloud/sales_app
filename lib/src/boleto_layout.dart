import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

Future<List<int>> generateBoletoLayout({
  required String customerName,
  required String totalPrice,
  required String expiredAt,
  required String barcode,
}) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> bytes = [];

  // Cabeçalho
  bytes += generator.text('BOLETO BANCÁRIO',
    styles: PosStyles(
    align: PosAlign.center,
    bold: true,
    height: PosTextSize.size2,
    width: PosTextSize.size2
  ));
  bytes += generator.text(
    'Cliente: $customerName',
    styles: PosStyles(align: PosAlign.left)
  );
  bytes += generator.text(
    'Valor: R\$$totalPrice',
    styles: PosStyles(align: PosAlign.left)
  );
  bytes += generator.text(
    'Vencimento: $expiredAt',
    styles: PosStyles(align: PosAlign.left)
  );

  bytes += generator.hr();

  // Rodapé
  bytes += generator.text(
    'Pague até o vencimento em qualquer banco.',
    styles: PosStyles(align: PosAlign.center)
  );
  bytes += generator.feed(2);
  bytes += generator.cut();

  return bytes;
}