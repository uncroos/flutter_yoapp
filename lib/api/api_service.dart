import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  static String? _apiKey;

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
    _apiKey = dotenv.env['OPENAI_API_KEY'];
  }

  static Future<String?> sendMessage(String message) async {
    if (_apiKey == null) {
      print("API 키가 설정되지 않았습니다.");
      return null;
    }

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey'
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": message}
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['choices'][0]['message']['content'];
    } else {
      print('API 요청 오류: ${response.statusCode}');
      return null;
    }
  }
}
