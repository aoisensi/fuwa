import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuwa/provider/preferences_provider.dart';
import 'package:fuwa/screen/login_screen.dart';

import 'screen/home_screen.dart';

class FuwaApp extends ConsumerWidget {
  const FuwaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcome = ref.watch(preferencesProvider).getDiscordTokens().isEmpty;
    return MaterialApp(
      title: 'Fuwa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: welcome ? const LoginScreen() : const HomeScreen(),
    );
  }
}
