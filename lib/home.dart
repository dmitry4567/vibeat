import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/features/signIn/presentation/bloc/auth_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.router.push(const SignInRoute());
        }
      },
      child: Scaffold(
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
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: const Text('Go to Profile'),
            ),
          ],
        )),
      ),
    );
  }
}
