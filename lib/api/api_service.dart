import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  static String? _apiKey;

  static Future<void> init() async {
    await dotenv.load(fileName: 'assets/config/.env');
    _apiKey = dotenv.env['GEMINI_API_KEY'];
  }

  static Future<String?> sendMessage(String message) async {
    if (_apiKey == null) {
      print("API 키가 설정되지 않았습니다.");
      return null;
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta2/models/gemini-pro:generateText');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey'
    };

    final body = jsonEncode({
      "prompt": {"text": message},
      "temperature": 0.7,
      "top_k": 40,
      "top_p": 0.95,
      "candidate_count": 1
    });

    final response =
        await http.post(url, headers: headers, body: body); // await 추가

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['candidates'][0]['output'];
    } else {
      print('API 요청 오류: ${response.statusCode}');
      print('에러 메시지: ${response.body}');
      return null;
    }
  }
}
