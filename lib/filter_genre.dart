import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FilterGenreScreen extends StatelessWidget {
  const FilterGenreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Genre'),
      ),
      body: const Center(
        child: Text('Filter Genre'),
      ),
    );
  }
}
