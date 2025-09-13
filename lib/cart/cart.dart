import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/cart/cart_item_model.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<BeatLicense> cartItems = [];

  @override
  void initState() {
    super.initState();

    getBeatsByCart();
  }

  Future<void> getBeatsByCart() async {
    final apiClient = sl<ApiClient>().dio;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    try {
      final response = await apiClient.get(
        "http://$ip:8080/cart/getByJWT",
      );

      if (response.statusCode == 200) {
        // Парсим JSON ответ
        final Map<String, dynamic> responseData = response.data is String
            ? json.decode(response.data)
            : response.data;

        // Проверяем статус и наличие данных
        if (responseData['status'] == true) {
          final List<dynamic> dataList = responseData['data']['licenses'];

          setState(() {
            cartItems =
                dataList.map((item) => BeatLicense.fromJson(item)).toList();
          });
        } else {
          setState(() {
            cartItems = [];
          });
        }
      } else if (response.statusCode == 500) {
        setState(() {
          cartItems = [];
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appbar,
        forceMaterialTransparency: true,
        title: const Text(
          "Корзина",
          style: AppTextStyles.bodyAppbar,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingWidth),
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CardItemWidget(
                  cartItemModel: cartItems[index],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CardItemWidget extends StatelessWidget {
  const CardItemWidget({
    super.key, required this.cartItemModel,
  });

  final BeatLicense cartItemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: const Color(0xff151515),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
        border: BoxBorder.all(
          color: Colors.white.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(28)),
                      child: Image.network(
                        fit: BoxFit.fitHeight,
                        width: 28,
                        height: 28,
                        'https://mimigram.ru/wp-content/uploads/2020/07/chto-takoe-foto.jpg',
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Skeletonizer(
                            enabled: true,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              child: Container(
                                width: 28,
                                height: 28,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            child: Container(
                              width: 28,
                              height: 28,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cartItemModel.beatmakerId,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: Image.network(
                          fit: BoxFit.fitHeight,
                          width: 60,
                          height: 60,
                          "f",
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Skeletonizer(
                              enabled: true,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItemModel.beatId,
                              style: AppTextStyles.headline1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Бит",
                              style: AppTextStyles.bodyText1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.more_vert,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 36, 36),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        cartItemModel.licenseTemplate.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Text(
                      "₽${cartItemModel.price}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: Material(
              color: AppColors.primary,
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(),
                  child: const Text(
                    "Оплатить",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
