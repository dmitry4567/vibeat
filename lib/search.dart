import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<BeatEntity> beatData = [];
  List<BeatEntity> placeholderData = List.generate(
    5,
    (index) => const BeatEntity(
        name: "",
        picture: "",
        beatmakerName: "",
        url: "",
        price: 1000,
        plays: 1000),
  );

  final TextEditingController textController1 = TextEditingController();

  @override
  void initState() {
    super.initState();

    getNewBeats();
  }

  void getNewBeats() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final response = await http.get(
      Uri.parse('http://192.168.0.135:7771/api/beat/beatsByDate/0/$now'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      log(data.toString());

      setState(() {
        beatData = data.map((json) => BeatEntity.fromJson(json)).toList();
      });
    }
    if (response.statusCode == 500) {
      beatData = [];
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;
    const double marginRight = 20.0;

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;
    final gridItemWidth = (size.width - paddingWidth * 2 - 20) / 2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.appbar,
        title: const Text('Поиск', style: AppTextStyles.bodyAppbar),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          context.read<PlayerBloc>().add(UpdatePlayerBottomEvent(true));
        },
        child: SingleChildScrollView(
          // physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: textController1,
                  onTap: () {
                    context.read<PlayerBloc>().add(
                          UpdatePlayerBottomEvent(false),
                        );
                  },
                  onTapOutside: (event) {
                    context.read<PlayerBloc>().add(
                          UpdatePlayerBottomEvent(true),
                        );
                  },
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.iconSecondary,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        context.pushRoute(const FilterRoute());
                      },
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.iconSecondary,
                      ),
                    ),
                    hintText: 'Type beat',
                    hintStyle: AppTextStyles.filterTextField,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.focusedBorderTextField,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundFilterTextField,
                    contentPadding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 7,
                      bottom: 7,
                    ),
                  ),
                  style: AppTextStyles.filterTextField,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Новые релизы", style: AppTextStyles.headline2),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.router.push(
                          PlaylistRoute(
                            title: "Новые релизы",
                            beats: beatData,
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Посмотреть",
                        style: AppTextStyles.bodyPrice1.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: beatData.isNotEmpty
                        ? List.generate(beatData.length, (index) {
                            return Skeletonizer(
                              enabled: false,
                              child: NewBeatWidget(
                                beat: beatData[index],
                                width: width,
                                marginRight: marginRight,
                                gridItemWidth: gridItemWidth,
                              ),
                            );
                          })
                        : List.generate(placeholderData.length, (index) {
                            return Skeletonizer(
                              enabled: true,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(right: marginRight),
                                  width: gridItemWidth,
                                  height: gridItemWidth,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }),
                  ),
                ),
                const SizedBox(height: 32),
                const Text("Горячие жанры", style: AppTextStyles.headline2),
                const SizedBox(height: 25),

                // GridView.builder(
                //   shrinkWrap: true,
                //   physics: const BouncingScrollPhysics(),
                //   itemCount: 12,
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     mainAxisExtent: (size.width - (paddingWidth * 2) - 15) / 3,
                //   ),
                //   itemBuilder: (_, index) => Container(
                //     margin: EdgeInsets.only(
                //       right: (index + 1) / 2 != 0 ? 15 : 0,
                //       bottom: 20,
                //     ),
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: Colors.white.withOpacity(0.1),
                //         width: 1,
                //       ),
                //       borderRadius: const BorderRadius.all(
                //         Radius.circular(6),
                //       ),
                //     ),
                //     child: Stack(
                //       children: [
                //         Positioned(
                //           top: 0,
                //           bottom: 0,
                //           left: 0,
                //           right: 0,
                //           child: Image.asset(
                //             fit: BoxFit.fitWidth,
                //             "assets/images/image1.png",
                //           ),
                //         ),
                //         Positioned(
                //           top: 0,
                //           bottom: 0,
                //           left: 0,
                //           right: 0,
                //           child: Container(
                //             color: Colors.black.withOpacity(0.4),
                //           ),
                //         ),
                //         const Positioned(
                //           top: 9,
                //           left: 9,
                //           child: Text(
                //             "Detroit",
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontFamily: "Poppins",
                //               fontWeight: FontWeight.w500,
                //               color: AppColors.textPrimary,
                //               letterSpacing: -0.41,
                //               height: 0.81,
                //             ),
                //           ),
                //         ),
                //         const Positioned(
                //           bottom: 9,
                //           right: 9,
                //           child: Text(
                //             "5000 битов",
                //             style: TextStyle(
                //               fontSize: 12,
                //               fontFamily: "Poppins",
                //               fontWeight: FontWeight.w400,
                //               color: AppColors.textPrimary,
                //               letterSpacing: -0.41,
                //               height: 0.54,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: (size.width - (paddingWidth * 2) - 10) / 3,
                  ),
                  itemBuilder: (_, index) => Skeletonizer(
                    enabled: false,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(
                          right: (index + 1) % 2 != 0 ? 15 : 0,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  "assets/images/genre${(index + 1)}.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              const Positioned(
                                top: 9,
                                left: 9,
                                child: Text(
                                  "Detroit",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.41,
                                    height: 0.81,
                                  ),
                                ),
                              ),
                              const Positioned(
                                bottom: 9,
                                right: 9,
                                child: Text(
                                  "5000 битов",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.41,
                                    height: 0.54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // GridView.count(
                //   crossAxisCount: 2,
                //   childAspectRatio: 1.5,
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   children: List.generate(12, (index) {
                //     return Container(
                //       height: 90,
                //       margin: EdgeInsets.only(
                //         right: (index + 1) / 2 != 0 ? 20 : 0,
                //         // left: (index + 1) / 2 == 0 ? 10 : 0,
                //         bottom: 20,
                //       ),
                //       color: Colors.red,
                //       alignment: Alignment.center,
                //       child: Text((index + 1).toString()),
                //     );
                //   },),
                // ),

                // ElevatedButton(
                //   onPressed: () {
                //     context.router.push(const PlayerRoute());
                //   },
                //   child: const Text('Go to Player'),
                // ),
                // const SizedBox(
                //   height: 40,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewBeatWidget extends StatelessWidget {
  final BeatEntity beat;
  final double width;
  final double marginRight;
  final double gridItemWidth;

  const NewBeatWidget({
    super.key,
    required this.beat,
    required this.width,
    required this.marginRight,
    required this.gridItemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(6),
      ),
      child: GestureDetector(
        onTap: () {
          context.read<PlayerBloc>().add(PlayAudioEvent());
          context.router.push(const PlayerRoute());
        },
        child: Container(
          width: width,
          margin: EdgeInsets.only(right: marginRight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(
              //   fit: BoxFit.fitWidth,
              //   width: width,
              //   "assets/images/image1.png",
              // ),
              Image.network(
                fit: BoxFit.fitHeight,
                width: gridItemWidth,
                height: gridItemWidth,
                beat.picture,
              ),
              const SizedBox(height: 6),
              Text(
                "${beat.price} RUB",
                style: AppTextStyles.bodyPrice2,
              ),
              Text(
                beat.name,
                style: AppTextStyles.headline1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png',
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  beat.beatmakerName == ''
                                      ? "beatmaker1"
                                      : beat.beatmakerName,
                                  style: AppTextStyles.bodyText2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.volume_down_outlined,
                        size: 12,
                        color: AppColors.unselectedItemColor,
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 1),
                          Text(
                            beat.plays.toString(),
                            style:
                                AppTextStyles.bodyText2.copyWith(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
