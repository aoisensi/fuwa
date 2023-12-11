import 'dart:async';

import 'package:fuwa/provider/credential_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../entity/user.dart';
import '../repository/discord_repository.dart';

final userProvider = AsyncNotifierProvider.family
    .autoDispose<UserNotifier, User, String>(UserNotifier.new,
        dependencies: [currentUserIdProvider]);

class UserNotifier extends AutoDisposeFamilyAsyncNotifier<User, String> {
  @override
  FutureOr<User> build(String arg) async {
    final repo = await ref.read(discordRepositoryProvider.future);
    return User.fromJson(await repo.user.getUser(arg));
  }

  void replace(User user) {
    state = AsyncValue.data(user);
  }
}
