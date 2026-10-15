import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const _baseKey = 'ai_base_url';
  static const _modelKey = 'ai_model';
  static const _secretKey = 'ai_api_key';

  Future<AiSettings> loadSettings() async {
    return AiSettings(
      baseUrl:
          await _secureStorage.read(key: _baseKey) ??
          'https://api.openai.com/v1',
      model: await _secureStorage.read(key: _modelKey) ?? 'gpt-5-mini',
      apiKey: await _secureStorage.read(key: _secretKey) ?? '',
    );
  }

  Future<void> saveSettings(AiSettings settings) async {
    await _secureStorage.write(key: _baseKey, value: settings.baseUrl.trim());
    await _secureStorage.write(key: _modelKey, value: settings.model.trim());
    if (settings.apiKey.trim().isEmpty) {
      await _secureStorage.delete(key: _secretKey);
    } else {
      await _secureStorage.write(
        key: _secretKey,
        value: settings.apiKey.trim(),
      );
    }
  }

  Future<String> reply({
    required AiSettings settings,
    required List<ChatLine> history,
    required String level,
  }) async {
    if (settings.apiKey.trim().isEmpty) {
      throw const AiException(
        'AI uchun API kalit sozlanmagan. Sozlamalardan API manzili va kalitni kiriting.',
      );
    }
    final base = settings.baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse('$base/chat/completions');
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw const AiException(
        'API manzili noto‘g‘ri. Masalan: https://api.openai.com/v1',
      );
    }
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content':
            'You are a warm, patient English conversation tutor for an Uzbek learner at CEFR $level. Reply in English in 2–5 short sentences. Keep the conversation moving with one natural question. If the learner makes an English error, first respond naturally, then add a brief correction with the correct phrase and a short Uzbek explanation. Do not claim to be human.',
      },
      ...history
          .take(20)
          .map(
            (line) => <String, String>{
              'role': line.isUser ? 'user' : 'assistant',
              'content': line.text,
            },
          ),
    ];
    final response = await http
        .post(
          uri,
          headers: {
            'Authorization': 'Bearer ${settings.apiKey}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': settings.model,
            'messages': messages,
            'temperature': 0.7,
          }),
        )
        .timeout(const Duration(seconds: 45));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      var detail = 'HTTP ${response.statusCode}';
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final error = data['error'];
        if (error is Map<String, dynamic> && error['message'] is String) {
          detail = error['message'] as String;
        }
      } catch (_) {
        // Keep the concise HTTP error when a provider returns non-JSON text.
      }
      throw AiException('AI xizmati javobi: $detail');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    String? content;
    if (choices != null && choices.isNotEmpty) {
      final choice = choices.first as Map<String, dynamic>;
      final message = choice['message'];
      if (message is Map<String, dynamic>) {
        content = message['content'] as String?;
      }
    }
    if (content is! String || content.trim().isEmpty) {
      throw const AiException(
        'AI dan bo‘sh javob keldi. Model nomi va endpointni tekshiring.',
      );
    }
    return content.trim();
  }
}

class AiSettings {
  const AiSettings({
    required this.baseUrl,
    required this.model,
    required this.apiKey,
  });
  final String baseUrl;
  final String model;
  final String apiKey;
}

class ChatLine {
  const ChatLine({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

class AiException implements Exception {
  const AiException(this.message);
  final String message;
  @override
  String toString() => message;
}
