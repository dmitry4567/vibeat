class MoodModel {
  final String name;
  final String key;
  final bool isSelected;

  const MoodModel({
    required this.name,
    required this.key,
    required this.isSelected,
  });

  MoodModel copyWith({
    String? name,
    String? key,
    bool? isSelected,
  }) {
    return MoodModel(
      name: name ?? this.name,
      key: key ?? this.key,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      name: json['name'],
      key: json['id'].toString(),
      isSelected: false,
    );
  }
}
