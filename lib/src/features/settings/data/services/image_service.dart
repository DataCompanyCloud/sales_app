import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageService {

  // Baixar imagem (mock)
  Future<File> downloadImage(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    return file.writeAsBytes(response.bodyBytes);
  }

  // Carregar imagem local
  Future<File> loadAssetImage(String assetPath, String fileName) async {
    final byteData = await rootBundle.load(assetPath);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    return file.writeAsBytes(byteData.buffer.asUint8List());
  }
}