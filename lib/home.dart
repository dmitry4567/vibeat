import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/features/auth/presentation/bloc/auth_bloc.dart';

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
              // context.pushRoute(const ProfileRoute());
              GetIt.I<AuthBloc>().add(SignOutRequested());
            },
            child: const Text('Go to Profile'),
          ),
        ],
      )),
    );
  }
}
