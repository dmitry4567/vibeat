import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test_routung2/main.gr.dart';

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
          Text("This is Home screen"),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              context.pushRoute(ProfileRoute());
            },
            child: const Text('Go to Profile'),
          ),
        ],
      )),
    );
  }
}
