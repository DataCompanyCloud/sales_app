// import 'dart:typed_data';
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:image/image.dart' as img;
//
// class PosPrinterService {
//   /// PaperSize.mm58 (largura ~32 colunas) ou PaperSize.mm80 (~48 colunas)
//   final PaperSize paperSize;
//   /// Perfil ESC/POS; use "default" quando não souber
//   final String capabilityProfileName;
//   CapabilityProfile? _profile;
//
//   PosPrinterService({
//     this.paperSize = PaperSize.mm58,
//     this.capabilityProfileName = 'default',
//   });
//
//   Future<void> _ensureProfile() async {
//     _profile ??= await CapabilityProfile.load(name: capabilityProfileName);
//   }
//
//   /// Faz scan por ~4s e retorna lista de dispositivos encontrados (name/macAddress).
//   Future<List<Map<String, String>>> scan({int timeoutMs = 4000}) async {
//     final result = await PrintBluetoothThermal.getBluetooths;
//     // result já retorna a lista de devices com 'name' e 'macAddress'
//     return result.map<Map<String, String>>((d) => {
//       'name': d['name'] ?? '',
//       'macAddress': d['macAddress'] ?? '',
//     }).toList();
//   }
//
//   /// Conecta na impressora pelo MAC.
//   Future<bool> connect(String macAddress) async {
//     final isConnected = await PrintBluetoothThermal.connectionStatus;
//     if (isConnected) return true;
//
//     final ok = await PrintBluetoothThermal.connect(macAddress: macAddress);
//     return ok;
//   }
//
//   /// Desconecta
//   Future<void> disconnect() async {
//     await PrintBluetoothThermal.disconnect;
//   }
//
//   /// Imprime um ticket simples de exemplo (texto + QRCode).
//   Future<void> printSample({
//     required String title,
//     List<String> lines = const [],
//     String? qrcodeData,
//     bool cut = false,
//     bool beep = false,
//     PosAlign titleAlign = PosAlign.center,
//   }) async {
//     await _ensureProfile();
//     final gen = Generator(paperSize, _profile!);
//     final List<int> bytes = [];
//
//     // Cabeçalho
//     bytes += gen.text(
//       title,
//       styles: const PosStyles(
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//         bold: true,
//       ),
//       linesAfter: 1,
//       align: titleAlign,
//     );
//
//     // Corpo
//     for (final ln in lines) {
//       bytes += gen.text(
//         ln,
//         styles: const PosStyles(
//           codeTable: PosCodeTable.wcp1252, // evita acentuação quebrada
//         ),
//       );
//     }
//
//     bytes += gen.hr(); // linha horizontal
//
//     if (qrcodeData != null && qrcodeData.isNotEmpty) {
//       bytes += gen.qrcode(qrcodeData, size: QRSize.Size5);
//       bytes += gen.feed(1);
//     }
//
//     // Rodapé
//     bytes += gen.text(
//       'Obrigado!',
//       styles: const PosStyles(align: PosAlign.center, bold: true),
//       linesAfter: 1,
//     );
//
//     if (beep) bytes += gen.beep();
//
//     if (cut && paperSize == PaperSize.mm80) {
//       // nem toda impressora 58mm tem guilhotina
//       bytes += gen.cut();
//     } else {
//       // alimenta algumas linhas
//       bytes += gen.feed(3);
//     }
//
//     await PrintBluetoothThermal.writeBytes(bytes);
//   }
//
//   /// Imprime uma imagem (logo) centralizada.
//   /// Passe um Uint8List de PNG/JPG já carregado.
//   Future<void> printImage(Uint8List imageBytes, {int maxWidthPx = 384}) async {
//     await _ensureProfile();
//     final gen = Generator(paperSize, _profile!);
//
//     img.Image? image = img.decodeImage(imageBytes);
//     if (image == null) return;
//
//     // Redimensiona para caber na largura da cabeça térmica
//     if (image.width > maxWidthPx) {
//       image = img.copyResize(image, width: maxWidthPx);
//     }
//
//     final bytes = <int>[];
//     bytes.addAll(gen.image(image, align: PosAlign.center));
//     bytes.addAll(gen.feed(1));
//
//     await PrintBluetoothThermal.writeBytes(bytes);
//   }
// }
