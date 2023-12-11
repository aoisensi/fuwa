import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final preferencesProvider = Provider<Preferences>(
  (ref) => Preferences(ref.watch(sharedPreferencesProvider)),
);

class Preferences {
  Preferences(this._sp);

  final SharedPreferences _sp;

  final _keyDiscordTokens = 'discord_tokens';

  List<oauth2.Credentials> getDiscordTokens() {
    final tokens = _sp.getStringList(_keyDiscordTokens) ?? [];
    return tokens.map((e) => oauth2.Credentials.fromJson(e)).toList();
  }

  void addDiscordToken(oauth2.Credentials token) {
    final tokens = getDiscordTokens();
    tokens.add(token);
    _sp.setStringList(
        _keyDiscordTokens, tokens.map((t) => t.toJson()).toList());
  }

  void updateDiscordToken(
      oauth2.Credentials oldToken, oauth2.Credentials newToken) {
    final tokens = getDiscordTokens()
        .map((t) =>
            (t.accessToken == oldToken.accessToken ? newToken : t).toJson())
        .toList();
    _sp.setStringList(_keyDiscordTokens, tokens);
  }
}
