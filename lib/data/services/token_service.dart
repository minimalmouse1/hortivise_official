// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

enum Environment {
  pronto(
    'Pronto',
    aliases: ['stream-calls-dogfood'],
  ),
  demo(
    'Demo',
    aliases: [''],
  ),
  staging(
    'Staging',
  );

  final String displayName;
  final List<String> aliases;

  const Environment(
    this.displayName, {
    this.aliases = const [],
  });

  factory Environment.fromSubdomain(String subdomain) {
    return Environment.values.firstWhere(
      (env) => env.name == subdomain || env.aliases.contains(subdomain),
      orElse: () => Environment.demo,
    );
  }

  factory Environment.fromHost(String host) {
    final hostParts = host.split('.');
    final envAlias = hostParts.length < 2 ? '' : hostParts[0];

    return Environment.fromSubdomain(envAlias);
  }
}

class TokenResponse {
  const TokenResponse(this.token, this.apiKey);

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      TokenResponse(json['token'], json['apiKey']);
  final String token;
  final String apiKey;
}

class TokenService {
  const TokenService();

  Future<String> create({
    required String userId,
  }) async {
    final jwt = JWT(
      {
        'user_id': userId,
      },
    );

// Sign it (default with HS256 algorithm)
    final token = jwt.sign(
      SecretKey(
        'qkcj3ksd7tvwrr656hyqjtnfgnqpjvqg42w7bwtt6fafgjef8v4sp6v4rgvygzsj',
      ),
    );

    print('Signed token: $token\n');
    return token;
  }
}
