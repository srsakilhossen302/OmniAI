import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AIService extends GetxService {
  // Use the API Key provided by the user
  static const String _apiKey = 'AIzaSyDB5IFzyCZCmze4_B5qunBxq_-8hNCIJMc';
  
  // Directly using the v1beta endpoint with full model path
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  // Generate text from a prompt
  Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [{"text": message}]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? "No response text found.";
      } else {
        print("AI API Error: ${response.statusCode} - ${response.body}");
        return "AI Error Details: ${response.body}";
      }
    } catch (e) {
      print("AI Service Exception: $e");
      return "AI Exception: $e";
    }
  }

  void resetChat() {
    // History handling can be added here if needed for direct API
  }
}
