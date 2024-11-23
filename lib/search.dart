import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test_routung2/main.gr.dart';

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
                context.pushRoute(FilterRoute());
              },
              child: const Text('Go to Filter'),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                context.router.push(const PlayerRoute());
              },
              child: const Text('Go to Player'),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
