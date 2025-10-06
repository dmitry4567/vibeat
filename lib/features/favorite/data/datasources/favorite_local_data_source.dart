import 'package:hive/hive.dart';

abstract class FavoriteLocalDataSource {
  Future<void> initLocalData({required Set<String> beatIds});
  Future<void> addToFavorite({required String beatId});
  Future<void> removeFromFavorite({required String beatId});
  bool isFavorite(String beatId);
  void clearAllDB();
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  const FavoriteLocalDataSourceImpl({required this.box});

  final Box<Set<String>> box;

  @override
  Future<void> initLocalData({required Set<String> beatIds}) async {
    await box.put('tracks', beatIds);
  }

  @override
  Future<void> addToFavorite({required String beatId}) async {
    final likedTracks = box.get('tracks', defaultValue: <String>{})!;
    final newSet = Set<String>.from(likedTracks)..add(beatId);
    await box.put('tracks', newSet);
  }

  @override
  Future<void> removeFromFavorite({required String beatId}) async {
    final likedTracks = box.get('tracks', defaultValue: <String>{})!;
    final newSet = Set<String>.from(likedTracks)..remove(beatId);
    await box.put('tracks', newSet);
  }

  @override
  bool isFavorite(String beatId) {
    final likedTracks = box.get('tracks', defaultValue: <String>{})!;

    return likedTracks.contains(beatId);
  }

  @override
  Future<void> clearAllDB() async {
    await box.clear();
  }
}

class StringSetAdapter extends TypeAdapter<Set<String>> {
  @override
  final int typeId = 0;

  @override
  Set<String> read(BinaryReader reader) {
    return Set<String>.from(reader.readList().cast<String>());
  }

  @override
  void write(BinaryWriter writer, Set<String> obj) {
    writer.writeList(obj.toList());
  }
}
