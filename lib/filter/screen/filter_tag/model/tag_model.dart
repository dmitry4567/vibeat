class TagModel {
  final String id;
  final String name;
  final bool isSelected;

  const TagModel({
    required this.id,
    required this.name,
    required this.isSelected,
  });

  TagModel copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return TagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'].toString(),
      name: json['Name'],
      isSelected: false,
    );
  }
}
