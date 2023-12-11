import 'dart:async';

import 'package:fuwa/provider/credential_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user.dart';
import '../repository/discord_repository.dart';

final currentUserProvider =
    AsyncNotifierProvider.autoDispose<CurrentUserNotifier, User>(
  CurrentUserNotifier.new,
  dependencies: [currentUserIdProvider],
);

class CurrentUserNotifier extends AutoDisposeAsyncNotifier<User> {
  @override
  FutureOr<User> build() async {
    final repo = await ref.read(discordRepositoryProvider.future);
    return User.fromJson(await repo.user.getCurrentUser());
  }

  void replace(User user) {
    state = AsyncValue.data(user);
  }
}
