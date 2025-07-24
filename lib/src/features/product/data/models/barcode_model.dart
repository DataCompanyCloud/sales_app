import 'package:objectbox/objectbox.dart';

@Entity()
class BarcodeModel {
  @Id()
  int id;

  @Unique()
  String type;
  String value;

  BarcodeModel ({
    this.id = 0,
    required this.type,
    required this.value
  });
}