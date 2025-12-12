import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/src/features/images/domain/repositories/local_image_repository.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

/// Repositório genérico para imagens locais baseado em sistema de arquivos.
///
/// - [rootDir] define o "bucket" onde as imagens serão salvas.
///   Exemplos:
///     - 'products/123'  (imagens do produto 123)
///     - 'users/45'      (imagens do usuário 45)
///     - 'avatars'       (imagens globais de avatar)
class FileSystemLocalImageRepository implements LocalImageRepository {
  final String rootDir;

  FileSystemLocalImageRepository({required this.rootDir});

  Directory? _rootDirFuture;
  Future<Directory> _getRootDirectory() async {
    if (_rootDirFuture != null) return _rootDirFuture!;

    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(appDir.path, 'images', rootDir));

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    _rootDirFuture = dir;
    return dir;
  }

  String _extensionFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.path.isEmpty) {
      return '.img';
    }

    final lastSegment =
    uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    final ext = p.extension(lastSegment); // inclui o ponto (.png)

    if (ext.isEmpty) {
      return '.img';
    }

    return ext;
  }

  String _fileNameFor(ImageEntity image) {
    final ext = _extensionFromUrl(image.url);
    return 'img_${image.code}$ext';
  }

  Future<File> _fileFor(ImageEntity image) async {
    final dir = await _getRootDirectory();
    final fileName = _fileNameFor(image);
    return File(p.join(dir.path, fileName));
  }

  @override
  Future<List<ImageEntity>> fetchMany(List<ImageEntity> images) async {
    // Versão para lista, reaproveitando a de única imagem
    final futures = images.map(fetchOne).toList();
    return Future.wait(futures);
  }

  @override
  Future<ImageEntity> fetchOne(ImageEntity image) async {
    final file = await _fileFor(image);

    if (await file.exists()) {
      return image.copyWith(localUrl: file.path);
    }

    return image.copyWith(localUrl: null);
  }

  @override
  Future<ImageEntity> save(ImageEntity image) async {
    final destFile = await _fileFor(image);
    final destPath = destFile.path;

    // Já estamos no lugar certo
    if (image.localUrl == destPath && await destFile.exists()) {
      return image;
    }

    // Sem localUrl → nada a salvar (quem baixa é outro serviço)
    if (image.localUrl == null || image.localUrl!.isEmpty) {
      return image;
    }

    final sourceFile = File(image.localUrl!);
    if (!await sourceFile.exists()) {
      return image.copyWith(localUrl: null);
    }

    // Copia para a pasta do rootDir com o nome padronizado
    await sourceFile.copy(destPath);
    // Opcional: deletar o arquivo de origem se for temporário

    return image.copyWith(localUrl: destPath);
  }

  @override
  Future<void> delete(ImageEntity image) async {
    final file = await _fileFor(image);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// (Opcional, mas útil)
  /// Remove todos os arquivos neste rootDir que NÃO pertencem à lista informada.
  ///
  /// Exemplo de uso:
  /// - você sincroniza as imagens de um produto/usuário
  /// - passa a lista de [currentImages] que ainda são válidas
  /// - este método apaga arquivos órfãos.
  Future<void> deleteAllNotIn(List<ImageEntity> currentImages) async {
    final dir = await _getRootDirectory();
    if (!await dir.exists()) return;

    final namesToKeep = currentImages.map(_fileNameFor).toSet();

    final entries = dir.listSync().whereType<File>();

    for (final file in entries) {
      final name = p.basename(file.path);
      if (!namesToKeep.contains(name)) {
        await file.delete();
      }
    }
  }

  /// (Opcional) Helper para baixar uma imagem e salvar direto neste rootDir.
  ///
  /// Se você quiser acoplar download aqui mesmo (e não em outro serviço),
  /// pode usar este método em vez de exigir um `localUrl` prévio.
  Future<ImageEntity> downloadAndSave(ImageEntity image) async {
    final destFile = await _fileFor(image);
    final destPath = destFile.path;

    // Se já está baixado, só retorna
    if (await destFile.exists()) {
      return image.copyWith(localUrl: destPath);
    }

    final response = await http.get(Uri.parse(image.url));
    if (response.statusCode != 200) {
      throw Exception('Erro ao baixar imagem (${image.url}): ${response.statusCode}');
    }

    await destFile.writeAsBytes(response.bodyBytes);
    return image.copyWith(localUrl: destPath);
  }
}
