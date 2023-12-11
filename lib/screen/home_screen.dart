import 'package:flutter/material.dart';
import 'package:fuwa/provider/credential_provider.dart';
import 'package:fuwa/widget/user/user_tile_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ref.watch(usersIdProvider).when(
            data: (ids) => Center(
                child: ListView.builder(
              itemCount: ids.length,
              itemBuilder: (context, index) {
                final id = ids[index];
                return ProviderScope(
                  overrides: [
                    currentUserIdProvider.overrideWithValue(id),
                  ],
                  child: UserTileWidget(id),
                );
              },
            )),
            error: (error, st) {
              return const Center(child: Text('Error'));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
