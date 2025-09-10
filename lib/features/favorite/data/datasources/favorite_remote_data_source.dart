import 'package:dio/dio.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/core/errors/exceptions.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<void> addToFavorite({required String beatId});
  Future<void> removeFromFavorite({required String beatId});
  Future<List<BeatModel>> getFavoriteBeats();
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  const FavoriteRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<void> addToFavorite({required String beatId}) async {
    try {
      final response = await apiClient.post(
        'activityBeat/postNewLike',
        options: Options(),
        data: {
          'beatId': beatId,
        },
      );
      if (response.statusCode != 201) {
        throw APIException(
          message: response.data['error'],
          statusCode: response.statusCode!,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> removeFromFavorite({required String beatId}) async {
    try {
      final response = await apiClient.delete(
        'activityBeat/$beatId',
      );
      if (response.statusCode != 200) {
        throw APIException(
          message: response.data,
          statusCode: response.statusCode!,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<BeatModel>> getFavoriteBeats() async {
    final response =
        await apiClient.get('activityBeat/viewMyLikes', options: Options());

    if (response.statusCode != 200) {
      throw APIException(
        message: response.data,
        statusCode: response.statusCode!,
      );
    }

    return (response.data['data'] as List)
        .map((item) => BeatModel.fromJson(item['beat']))
        .toList();
  }
}
