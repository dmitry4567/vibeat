class AnketaModel {
  final String id;
  final String name;

  AnketaModel({required this.id, required this.name});

  factory AnketaModel.fromJson(Map<String, dynamic> json) {
    return AnketaModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}