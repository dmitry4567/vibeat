class GenreModel {
  final String name;
  final int countOfBeats;
  final String key;
  final String photoUrl;
  final bool isSelected;

  const GenreModel({
    required this.name,
    required this.countOfBeats,
    required this.key,
    required this.photoUrl,
    required this.isSelected,
  });

  GenreModel copyWith({
    String? name,
    int? countOfBeats,
    String? key,
    String? photoUrl,
    bool? isSelected,
  }) {
    return GenreModel(
      name: name ?? this.name,
      countOfBeats: countOfBeats ?? this.countOfBeats,
      key: key ?? this.key,
      photoUrl: photoUrl ?? this.photoUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      name: json['name'],
      countOfBeats: json['countOfBeats'] ?? 300,
      key: json['id'].toString(),
      photoUrl: json['photoUrl'] ?? '',
      isSelected: false,
    );
  }
}
