import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/main.gr.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;
    const double marginRight = 20.0;

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;

    final textController1 = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.appbar,
        title: const Text(
          'Поиск',
          style: AppTextStyles.bodyAppbar,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          // physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: textController1,
                  obscureText: false,
                  autofocus: false,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.iconSecondary,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          context.pushRoute( FilterRoute());
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
                      )),
                  style: AppTextStyles.filterTextField,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Новые релизы",
                      style: AppTextStyles.headline2,
                    ),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Посмотреть",
                        style: AppTextStyles.bodyPrice1
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      6,
                      (index) {
                        return Skeletonizer(
                          enabled: false,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: Container(
                              width: width,
                              margin: const EdgeInsets.only(right: marginRight),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    fit: BoxFit.fitWidth,
                                    width: width,
                                    "assets/images/image1.png",
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  const Text(
                                    "1000 RUB",
                                    style: AppTextStyles.bodyPrice2,
                                  ),
                                  const Text(
                                    "Detroit type beat sefsef sef",
                                    style: AppTextStyles.headline1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  right: 5,
                                                ),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "Rany sefsefsefsefsef se fs ef se fsefsefseefsefsef",
                                                      style: AppTextStyles
                                                          .bodyText2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                            color:
                                                AppColors.unselectedItemColor,
                                          ),
                                          Column(
                                            children: [
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              Text(
                                                "100k",
                                                style: AppTextStyles.bodyText2
                                                    .copyWith(fontSize: 10),
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
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "Горячие жанры",
                  style: AppTextStyles.headline2,
                ),
                const SizedBox(
                  height: 25,
                ),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
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
