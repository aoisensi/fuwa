import 'package:flutter/material.dart';
import 'package:fuwa/screen/home_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuwa/discord/repository/discord_login_repository.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(discordLoginRepositoryProvider).redirect();
              },
              child: const Text('Login'),
            ),
            TextField(
              controller: codeController,
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(discordLoginRepositoryProvider)
                    .login(codeController.text)
                    .then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                });
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
