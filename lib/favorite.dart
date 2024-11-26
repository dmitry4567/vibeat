import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        title: const Text(
          'Избранное',
          style: AppTextStyles.bodyAppbar,
        ),
      ),
      body: const Center(
        child: Text('This is Favorite Screen'),
      ),
    );
  }
}
