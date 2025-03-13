class KeyModel {
  final String name;
  final String key;
  final bool isSelected;

  const KeyModel({
    required this.name,
    required this.key,
    required this.isSelected,
  });

  KeyModel copyWith({
    String? name,
    String? key,
    bool? isSelected,
  }) {
    return KeyModel(
      name: name ?? this.name,
      key: key ?? this.key,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory KeyModel.fromJson(Map<String, dynamic> json) {
    return KeyModel(
      name: json['name'],
      key: json['key'],
      isSelected: false,
    );
  }
}
