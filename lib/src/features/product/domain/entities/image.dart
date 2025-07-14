class ImageModel {
  final int id;
  final String url;

  ImageModel({
    required this.id,
    required this.url
  }) {

    if (id <= 0) {
      throw ArgumentError('IamgeModel: "id" cannot be negative.');
    }
    if (url.trim().isEmpty) {
      throw ArgumentError('ImageModel: "url" cannot be null.');
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      throw ArgumentError('ImageModel: "url" invalid.');
    }
  }
}