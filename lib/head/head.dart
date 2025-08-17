import 'dart:convert';
import 'dart:developer' as d;
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/features/signIn/presentation/bloc/auth_bloc.dart';
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class HeadScreen extends StatefulWidget {
  const HeadScreen({super.key});

  @override
  State<HeadScreen> createState() => _HeadScreenState();
}

class _HeadScreenState extends State<HeadScreen> {
  List<MoodModel> moodData = [];
  List<MoodModel> placeholderData = List.generate(
    5,
    (index) => const MoodModel(
      name: "1",
      key: "1",
      isSelected: false,
    ),
  );
  List<TagModel> tagData = [];

  @override
  void initState() {
    super.initState();

    getMoodData();
    getTrendTagsData();
  }

  void getMoodData() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.135:8080/metadata/moods'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      setState(() {
        moodData = data.map((json) => MoodModel.fromJson(json)).toList();
      });
    }
  }

  void getTrendTagsData() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.135:8080/metadataBeat/tags/in_trend'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      setState(() {
        tagData = data.map((json) => TagModel.fromJson(json)).toList();
        tagData = tagData.take(20).toList();
      });
    }
  }

  final List<String> tags = [
    '#hardstyle',
    '#lo-fi',
    '#drill',
    '#love_music',
    '#winter',
    '#detroit',
    '#hardstyle',
    '#lo-fi',
    '#drill',
    '#love_music',
    '#winter',
    '#detroit',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;
    const double marginRight = 20.0;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignOut) {
          context.router.replaceAll([const SignInRoute()]);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Главная',
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                      ),
                    ),
                  ],
                ),
              ),

              const SliverPadding(
                padding: EdgeInsets.only(top: 40),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Специально для вас',
                    style: AppTextStyles.headline2,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: size.width / 2 - 36 + 10,
                          height: size.width / 2 - 36 + 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xff8D40FF).withOpacity(0.9),
                                const Color(0xff8D40FF).withOpacity(0.4),
                              ],
                            ),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          child: const Center(
                            child: Text(
                              "Моя волна",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: "Helvetica",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width / 2 - 36 + 10,
                          height: size.width / 2 - 36 + 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color.fromARGB(255, 231, 100, 0)
                                    .withOpacity(0.9),
                                const Color.fromARGB(255, 231, 100, 0)
                                    .withOpacity(0.4),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Новинки\nваших\nбитмейкеров",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                height: 1.2,
                                fontFamily: "Helvetica",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Container(
              //     padding: const EdgeInsets.only(top: 20),
              //     height: 177,
              //     child: ListView(
              //       scrollDirection: Axis.horizontal,
              //       children: [
              //         Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(6),
              //             gradient: LinearGradient(
              //               begin: Alignment.topLeft,
              //               end: Alignment.bottomRight,
              //               colors: [
              //                 const Color(0xff8D40FF).withOpacity(0.9),
              //                 const Color(0xff8D40FF).withOpacity(0.4),
              //               ],
              //             ),
              //           ),
              //           margin: const EdgeInsets.only(right: 10),
              //           width: 177,
              //           child: const Center(
              //             child: Text(
              //               "Моя волна",
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 24,
              //                 fontFamily: "Helvetica",
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //         ),
              //         Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(6),
              //             gradient: LinearGradient(
              //               begin: Alignment.topLeft,
              //               end: Alignment.bottomRight,
              //               colors: [
              //                 const Color.fromARGB(255, 231, 100, 0)
              //                     .withOpacity(0.9),
              //                 const Color.fromARGB(255, 231, 100, 0)
              //                     .withOpacity(0.4),
              //               ],
              //             ),
              //           ),
              //           margin: const EdgeInsets.only(right: 10),
              //           width: 177,
              //           child: const Center(
              //             child: Text(
              //               "Новинки\nваших\nбитмейкеров",
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 24,
              //                 height: 1.2,
              //                 fontFamily: "Helvetica",
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 32),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'По настроению',
                    style: AppTextStyles.headline2,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: size.width / 2 - 36 + 10,
                  height: size.width / 2 - 36 + 10,
                  child: moodData.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: moodData.length,
                          itemBuilder: (context, index) {
                            final randomColor =
                                (Random().nextDouble() * 0xFFFFFF + 0x888888)
                                    .toInt();
                            // final randomColor =
                            // Random().nextInt(0x777777) + 0x888888;
                            return GestureDetector(
                              onTap: () {
                                context.router.push(PlaylistMoodRoute(
                                  mood: moodData[index],
                                ));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(randomColor).withOpacity(0.8),
                                      Color(randomColor).withOpacity(0.3),
                                    ],
                                  ),
                                ),
                                width: size.width / 2 - 36 + 10,
                                height: size.width / 2 - 36 + 10,
                                child: Center(
                                  child: Text(
                                    moodData[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            5,
                            (index) => Skeletonizer(
                              enabled: true,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  color: Colors.black,
                                  width: 177,
                                  height: 177,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              // const SliverPadding(
              //   padding: EdgeInsets.only(top: 32),
              //   sliver: SliverToBoxAdapter(
              //     child: Text(
              //       'От редакции',
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontFamily: "Helvetica",
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: Container(
              //     padding: const EdgeInsets.only(top: 20),
              //     height: 177,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: 20,
              //       itemBuilder: (context, index) {
              //         return Container(
              //           margin: const EdgeInsets.only(right: 10),
              //           width: 177,
              //           color: Colors.red,
              //           child: Center(
              //             child: Text('Item $index'),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 32),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Теги в тренде',
                    style: AppTextStyles.headline2,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 20),
                sliver: SliverToBoxAdapter(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: tagData.map((tag) => TagItem(tag: tag)).toList(),
                  ),
                ),
              ),
              //   const SliverPadding(
              //     padding: EdgeInsets.only(top: 32),
              //     sliver: SliverToBoxAdapter(
              //       child: Text(
              //         'Новые биты популярных авторов',
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontFamily: "Helvetica",
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),
              //   ),
              //   SliverPadding(
              //     padding: const EdgeInsets.only(top: 20),
              //     sliver: SliverToBoxAdapter(
              //       child: SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           children: List.generate(
              //             6,
              //             (index) {
              //               return Skeletonizer(
              //                 enabled: false,
              //                 child: ClipRRect(
              //                   borderRadius: const BorderRadius.all(
              //                     Radius.circular(6),
              //                   ),
              //                   child: GestureDetector(
              //                     onTap: () {},
              //                     child: Container(
              //                       width: width,
              //                       margin:
              //                           const EdgeInsets.only(right: marginRight),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Image.asset(
              //                             fit: BoxFit.fitWidth,
              //                             width: width,
              //                             "assets/images/image1.png",
              //                           ),
              //                           const SizedBox(
              //                             height: 6,
              //                           ),
              //                           const Text(
              //                             "1000 RUB",
              //                             style: AppTextStyles.bodyPrice2,
              //                           ),
              //                           const Text(
              //                             "Detroit type beat sefsef sef",
              //                             style: AppTextStyles.headline1,
              //                             overflow: TextOverflow.ellipsis,
              //                           ),
              //                           const SizedBox(
              //                             height: 8,
              //                           ),
              //                           Row(
              //                             mainAxisAlignment:
              //                                 MainAxisAlignment.spaceBetween,
              //                             children: [
              //                               Expanded(
              //                                 child: Row(
              //                                   children: [
              //                                     const SizedBox(
              //                                       width: 12,
              //                                       height: 12,
              //                                       child: CircleAvatar(
              //                                         backgroundImage:
              //                                             NetworkImage(
              //                                           'https://static-cse.canva.com/blob/191106/00_verzosa_winterlandscapes_jakob-owens-tb-2640x1485.jpg',
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     const SizedBox(
              //                                       width: 4,
              //                                     ),
              //                                     Expanded(
              //                                       child: Container(
              //                                         padding:
              //                                             const EdgeInsets.only(
              //                                           right: 5,
              //                                         ),
              //                                         child: Column(
              //                                           children: [
              //                                             const SizedBox(
              //                                               height: 2,
              //                                             ),
              //                                             Text(
              //                                               "Rany sefsefsefsefsef se fs ef se fsefsefseefsefsef",
              //                                               style: AppTextStyles
              //                                                   .bodyText2,
              //                                               overflow: TextOverflow
              //                                                   .ellipsis,
              //                                             ),
              //                                           ],
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               Row(
              //                                 children: [
              //                                   Icon(
              //                                     Icons.volume_down_outlined,
              //                                     size: 12,
              //                                     color: AppColors
              //                                         .unselectedItemColor,
              //                                   ),
              //                                   Column(
              //                                     children: [
              //                                       const SizedBox(
              //                                         height: 1,
              //                                       ),
              //                                       Text(
              //                                         "100k",
              //                                         style: AppTextStyles
              //                                             .bodyText2
              //                                             .copyWith(fontSize: 10),
              //                                         overflow:
              //                                             TextOverflow.ellipsis,
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ],
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              //   const SliverPadding(
              //     padding: EdgeInsets.only(top: 32),
              //     sliver: SliverToBoxAdapter(
              //       child: Text(
              //         'Биты новоприбывших авторов',
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontFamily: "Helvetica",
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),
              //   ),
              //   SliverPadding(
              //     padding: const EdgeInsets.only(top: 20),
              //     sliver: SliverToBoxAdapter(
              //       child: SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           children: List.generate(
              //             6,
              //             (index) {
              //               return Skeletonizer(
              //                 enabled: false,
              //                 child: ClipRRect(
              //                   borderRadius: const BorderRadius.all(
              //                     Radius.circular(6),
              //                   ),
              //                   child: GestureDetector(
              //                     onTap: () {},
              //                     child: Container(
              //                       width: width,
              //                       margin:
              //                           const EdgeInsets.only(right: marginRight),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Image.asset(
              //                             fit: BoxFit.fitWidth,
              //                             width: width,
              //                             "assets/images/image1.png",
              //                           ),
              //                           const SizedBox(
              //                             height: 6,
              //                           ),
              //                           const Text(
              //                             "1000 RUB",
              //                             style: AppTextStyles.bodyPrice2,
              //                           ),
              //                           const Text(
              //                             "Detroit type beat sefsef sef",
              //                             style: AppTextStyles.headline1,
              //                             overflow: TextOverflow.ellipsis,
              //                           ),
              //                           const SizedBox(
              //                             height: 8,
              //                           ),
              //                           Row(
              //                             mainAxisAlignment:
              //                                 MainAxisAlignment.spaceBetween,
              //                             children: [
              //                               Expanded(
              //                                 child: Row(
              //                                   children: [
              //                                     const SizedBox(
              //                                       width: 12,
              //                                       height: 12,
              //                                       child: CircleAvatar(
              //                                         backgroundImage:
              //                                             NetworkImage(
              //                                           'https://static-cse.canva.com/blob/191106/00_verzosa_winterlandscapes_jakob-owens-tb-2640x1485.jpg',
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     const SizedBox(
              //                                       width: 4,
              //                                     ),
              //                                     Expanded(
              //                                       child: Container(
              //                                         padding:
              //                                             const EdgeInsets.only(
              //                                           right: 5,
              //                                         ),
              //                                         child: Column(
              //                                           children: [
              //                                             const SizedBox(
              //                                               height: 2,
              //                                             ),
              //                                             Text(
              //                                               "Rany sefsefsefsefsef se fs ef se fsefsefseefsefsef",
              //                                               style: AppTextStyles
              //                                                   .bodyText2,
              //                                               overflow: TextOverflow
              //                                                   .ellipsis,
              //                                             ),
              //                                           ],
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               Row(
              //                                 children: [
              //                                   Icon(
              //                                     Icons.volume_down_outlined,
              //                                     size: 12,
              //                                     color: AppColors
              //                                         .unselectedItemColor,
              //                                   ),
              //                                   Column(
              //                                     children: [
              //                                       const SizedBox(
              //                                         height: 1,
              //                                       ),
              //                                       Text(
              //                                         "100k",
              //                                         style: AppTextStyles
              //                                             .bodyText2
              //                                             .copyWith(fontSize: 10),
              //                                         overflow:
              //                                             TextOverflow.ellipsis,
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ],
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  final TagModel tag;

  const TagItem({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.tabsRouter.setActiveIndex(1);
        // context.pushRoute(
        //   ResultRoute(
        //     tags: [tag],
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff6E4985),
              Color(0xff44255C),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tag.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
