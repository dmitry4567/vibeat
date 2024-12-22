import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/app/app_router.gr.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("This is Home screen"),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              context.pushRoute(const ProfileRoute());
            },
            child: const Text('Go to Profile'),
          ),
        ],
      )),
    );
  }
}
