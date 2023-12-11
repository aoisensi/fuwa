import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuwa/discord/provider/current_user_provider.dart';

class UserTileWidget extends ConsumerWidget {
  const UserTileWidget(this.id, {super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider).when(
          data: (user) => ListTile(
            title: Text(user.username),
            subtitle: Text(user.id),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ),
          error: (error, st) {
            throw error;
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
