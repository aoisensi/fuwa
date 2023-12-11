import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuwa/provider/preferences_provider.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

final discordLoginRepositoryProvider = Provider(DiscordLoginRepository.new);

class DiscordLoginRepository {
  DiscordLoginRepository(this.ref);

  final _authEndpoint = Uri.parse('https://discord.com/oauth2/authorize');
  final _tokenEndpoint = Uri.parse('https://discord.com/api/oauth2/token');
  final _redirectUrl = Uri.parse('http://example.com');
  final _scopes = ['identify', 'guilds'];

  oauth2.AuthorizationCodeGrant? grant;

  // Redirect to Discord's OAuth2 page
  Future<void> redirect() async {
    grant = oauth2.AuthorizationCodeGrant(
      dotenv.env['DISCORD_CLIENT_ID']!,
      _authEndpoint,
      _tokenEndpoint,
      secret: dotenv.env['DISCORD_CLIENT_SECRET']!,
    );

    final url = grant!.getAuthorizationUrl(_redirectUrl, scopes: _scopes);

    await launchUrl(url);
  }

  Future<void> login(String code) async {
    final client = await grant!.handleAuthorizationResponse({'code': code});
    final credentials = client.credentials;
    final preferences = ref.read(preferencesProvider);
    preferences.addDiscordToken(credentials);
  }

  final Ref ref;
}
