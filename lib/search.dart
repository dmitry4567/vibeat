import 'dart:convert';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:vibeat/widgets/beat_widget.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<GenreModel> genresData = [];
  List<BeatModel> placeholderBeat = List.generate(
    5,
    (index) => const BeatModel(
      id: "",
      name: "",
      description: "",
      picture: "",
      beatmakerId: "",
      beatmakerName: "",
      url: "",
      price: 1000,
      plays: 1000,
      genres: [],
      moods: [],
      tags: [],
      key: KeyModel(
        name: "",
        key: "",
        isSelected: false,
      ),
      bpm: 0,
      createAt: 0,
    ),
  );

  List<GenreModel> placeholderGenre = List.generate(
    4,
    (index) => const GenreModel(
        name: "skjrngfs",
        countOfBeats: 300,
        key: "",
        photoUrl: "",
        isSelected: false),
  );

  List<BeatModel> beatData = [];

  final TextEditingController textController1 = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() {
      getNewBeats();
      getGenres();
      return Future.value(true);
    });
  }

  @override
  void initState() {
    super.initState();

    getNewBeats();
    getGenres();
  }

  void getNewBeats() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.get(
      Uri.parse('http://$ip:8080/beat/beatsByDate/0/$now'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      setState(() {
        beatData = data.map((json) => BeatModel.fromJson(json)).toList();
      });
    }
    if (response.statusCode == 500) {
      beatData = [];
    }
  }

  void getGenres() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");
    final response = await http.get(
      Uri.parse('http://$ip:8080/metadata/genres'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      setState(() {
        genresData = data.map((json) => GenreModel.fromJson(json)).toList();
      });
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
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.appbar,
        title: const Text('Поиск', style: AppTextStyles.bodyAppbar),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          sl<PlayerBloc>().add(UpdatePlayerBottomEvent(true));
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
                  onFieldSubmitted: (value) {
                    if (value != "") {
                      context.router.push(ResultRoute(
                        query: value,
                      ));
                    }
                  },
                  onTap: () {
                    sl<PlayerBloc>().add(
                      UpdatePlayerBottomEvent(false),
                    );
                  },
                  onTapOutside: (event) {
                    sl<PlayerBloc>().add(
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
                    const Text(
                      "Новые релизы",
                      style: AppTextStyles.headline2,
                    ),
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
                        ? List.generate(100, (index) {
                            return Skeletonizer(
                              enabled: false,
                              child: NewBeatWidget(
                                openPlayer: () {
                                  sl<PlayerBloc>().add(
                                      PlayCurrentBeatEvent(beatData, index));

                                  context.router.navigate(const PlayerRoute());
                                },
                                openInfoBeat: () {
                                  context.router.navigate(
                                    InfoBeat(
                                      beatId: beatData[index].id,
                                    ),
                                  );
                                },
                                isLoading: false,
                                index: index,
                                beat: beatData[index],
                                width: width,
                                marginRight: marginRight,
                                gridItemWidth: gridItemWidth,
                                typeOfBeat: TypeOfBeat.defaultBeat,
                              ),
                            );
                          })
                        : List.generate(placeholderBeat.length, (index) {
                            return Skeletonizer(
                              enabled: true,
                              child: NewBeatWidget(
                                openPlayer: () {},
                                openInfoBeat: () {},
                                isLoading: true,
                                index: index,
                                beat: const BeatModel(
                                  id: "",
                                  name: "sefsesfseff",
                                  description: "sefsef",
                                  picture: "",
                                  beatmakerId: "",
                                  beatmakerName: "sefsef",
                                  url: "",
                                  price: 0,
                                  plays: 0,
                                  genres: [],
                                  moods: [],
                                  tags: [],
                                  key: KeyModel(
                                    name: "",
                                    key: "",
                                    isSelected: false,
                                  ),
                                  bpm: 0,
                                  createAt: 0,
                                ),
                                width: width,
                                marginRight: marginRight,
                                gridItemWidth: gridItemWidth,
                                typeOfBeat: TypeOfBeat.defaultBeat,
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
                genresData.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: genresData.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent:
                              (size.width - (paddingWidth * 2) - 10) / 3,
                        ),
                        itemBuilder: (_, index) => GenreWidget(
                          index: index % 4,
                          genre: genresData[index],
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: placeholderGenre.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent:
                              (size.width - (paddingWidth * 2) - 10) / 3,
                        ),
                        itemBuilder: (_, index) => Skeletonizer(
                          enabled: true,
                          child: GenreWidget(
                            index: index,
                            genre: placeholderGenre[index],
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

class GenreWidget extends StatelessWidget {
  const GenreWidget({super.key, required this.index, required this.genre});

  final int index;
  final GenreModel genre;

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    return GestureDetector(
      onTap: () {
        context.router.push(ResultRoute(
          genres: [genre],
        ));
      },
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
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                top: 9,
                left: 9,
                child: Text(
                  genre.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.41,
                    height: 0.81,
                  ),
                ),
              ),
              Positioned(
                bottom: 9,
                right: 9,
                child: Text(
                  "${random.nextInt(500)} битов",
                  style: const TextStyle(
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
    );
  }
}
