import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuwa/discord/repository/discord_repository.dart';
import 'package:fuwa/provider/preferences_provider.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:tuple/tuple.dart';

import '../discord/entity/user.dart';

typedef _ClientPair = Tuple3<int, http.Client, String>; // index client id

final _discordClientsProvider = FutureProvider<List<_ClientPair>>((ref) async {
  final prefs = ref.watch(preferencesProvider);
  final clients = prefs.getDiscordTokens().map(oauth2.Client.new).toList();
  final result = <_ClientPair>[];
  for (var i = 0; i < clients.length; i++) {
    final client = clients[i];
    final repo = DiscordRepository(ref, client);
    final body = await repo.user.getCurrentUser(); // TODO: use `all`
    final account = User.fromJson(body);
    result.add(Tuple3(i, client, account.id));
  }
  return result;
});

final usersIdProvider = FutureProvider<List<String>>((ref) async {
  final clients = await ref.watch(_discordClientsProvider.future);
  return clients.map((c) => c.item3).toList();
});

final discordRepositories =
    FutureProvider.family<DiscordRepository, String>((ref, id) async {
  final clients = await ref.watch(_discordClientsProvider.future);
  for (final client in clients) {
    if (client.item3 == id) {
      return DiscordRepository(ref, client.item2);
    }
  }
  throw Exception('No such client');
});

final currentUserIdProvider = Provider<String>(
  (e) => throw UnimplementedError("No set currentAccountIdProvider"),
);
