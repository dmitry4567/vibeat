class TagModel {
  final String name;
  final bool isSelected;

  const TagModel({
    required this.name,
    required this.isSelected,
  });

  TagModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return TagModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      name: json['name'],
      isSelected: false,
    );
  }
}
