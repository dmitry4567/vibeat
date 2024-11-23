import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test_routung2/main.gr.dart';

@RoutePage()
class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              context.router.push(const ResultRoute());
            },
            child: const Text('Go to Result'),
          ),
        ],
        title: const Text('Поиск'),
      ),
      body: SizedBox(
        height: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
              context.router.push(const FilterGenreRoute());
              },
              child: Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 20),
                color: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
