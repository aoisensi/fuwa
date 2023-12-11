import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuwa/provider/credential_provider.dart';
import 'package:http/http.dart' as http;

part 'discord_user_repository.dart';

final discordRepositoryProvider =
    FutureProvider<DiscordRepository>((ref) async {
  final accountId = ref.watch(currentUserIdProvider);
  return await ref.watch(discordRepositories(accountId).future);
}, dependencies: [currentUserIdProvider]);

class DiscordRepository {
  DiscordRepository(this.ref, this.client);

  final Ref ref;
  final http.Client client;
  Uri _url(String path) => Uri.parse('https://discord.com/api/v10$path');

  DiscordUserRepository get user => DiscordUserRepository._(this);

  Future<dynamic> _get(String path) async {
    final response = await client.get(_url(path));
    final sc = response.statusCode;
    if (300 < sc || sc < 200) {
      throw Exception('Failed to get $path: ${response.statusCode}');
    }
    return json.decode(utf8.decode(response.bodyBytes));
  }
}
