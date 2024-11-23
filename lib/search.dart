import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/main.gr.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushRoute(const FilterRoute());
              },
              child: const Text('Go to Filter'),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                context.router.push(const PlayerRoute());
              },
              child: const Text('Go to Player'),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
