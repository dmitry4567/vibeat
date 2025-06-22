import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<BeatEntity> beatData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() {
      getFavoriteBeats();
      return Future.value(true);
    });
  }

  @override
  void initState() {
    super.initState();

    getFavoriteBeats();
  }

  void getFavoriteBeats() async {
    final apiClient = sl<ApiClient>().dio;

    try {
      final response = await apiClient.get(
        "http://192.168.0.135:8080/activityBeat/viewMyLikes",
      );

      if (response.statusCode == 200) {
        // Парсим JSON ответ
        final Map<String, dynamic> responseData = response.data is String
            ? json.decode(response.data)
            : response.data;

        // Проверяем статус и наличие данных
        if (responseData['status'] == true) {
          final List<dynamic> dataList = responseData['data'];

          log(dataList.toString());

          setState(() {
            beatData = dataList
                .map((item) => BeatEntity.fromJson(item['beat']))
                .toList();
          });
        } else {
          // Если status false, устанавливаем пустой список
          setState(() {
            beatData = [];
          });
        }
      } else if (response.statusCode == 500) {
        setState(() {
          beatData = [];
        });
      }
    } catch (e) {
      log('Error fetching favorite beats: $e');
      setState(() {
        beatData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const paddingWidth = 18.0;
    final gridItemWidth = (size.width - paddingWidth * 2 - 20) / 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        forceMaterialTransparency: true,
        title: const Text(
          "Избранное",
          style: AppTextStyles.bodyAppbar,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingWidth),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  childCount: beatData.length,
                  (context, index) {
                    return Skeletonizer(
                      enabled: false,
                      child: BeatWidget(
                        gridItemWidth: gridItemWidth,
                        beat: beatData[index],
                      ),
                    );
                  },
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: gridItemWidth + 67,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
