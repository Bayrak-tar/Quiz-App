import 'package:mobil_final_odevi/core/models/soru_model.dart';
import 'package:uuid/uuid.dart';

class Test {
  String id;
  String testBaslik;
  List<Soru> sorular;

  Test({required this.testBaslik, required this.sorular})
      : id = Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'testTitle': testBaslik,
      'sorular': sorular.map((soru) => soru.toMap()).toList(),
    };
  }

  Test.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        testBaslik = map['testTitle'] ?? '',
        sorular = (map['sorular'] != null)
            ? (map['sorular'] as List<dynamic>)
            .map((soru) => Soru.fromMap(soru is Map<String, dynamic> ? soru : {}))
            .toList()
            : [];

  factory Test.fromFirestore(Map<String, dynamic> map) {
    return Test(
      testBaslik: map['testTitle'] ?? '',
      sorular: (map['sorular'] != null)
          ? (map['sorular'] as List<dynamic>)
          .map((soru) => Soru.fromMap(soru is Map<String, dynamic> ? soru : {}))
          .toList()
          : [],
    );
  }
}