part of 'discord_repository.dart';

class DiscordUserRepository {
  DiscordUserRepository._(this.repo);

  final DiscordRepository repo;

  // https://discord.com/developers/docs/resources/user#get-user
  Future<dynamic> getUser(String userId) => repo._get('/users/$userId');

  // https://discord.com/developers/docs/resources/user#get-current-user
  Future<dynamic> getCurrentUser() => getUser('@me');
}
