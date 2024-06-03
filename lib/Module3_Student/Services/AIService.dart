import "dart:convert";

import "package:http/http.dart" as http;

class AIServices {
  static final AIServices _instance = AIServices._internal();

  factory AIServices() {
    return _instance;
  }

  AIServices._internal();

  // ignore: non_constant_identifier_names
  final OPENAI_API_KEY = "sk-proj-NCKJXmWbeytaeFTetUNUT3BlbkFJONMlNoGByiYX9rBCm3fK";

  Future<String> evaluate(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAI_API_KEY',
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": "The user has completed an assessment to determine their preferred learning styles. Please analyze the results of the assessment with the following information in mind:\n\n" 
                      "Learning Styles:\n"
                      "1. Visual: The user prefers to learn through seeing. This includes the use of images or videos.\n"
                      "2. Reading: The user prefers to learn through reading and writing. This includes text-based materials.\n"
                      "3. Kinesthetic: The user prefers to learn through physical activity and hands-on experiences. This includes practical activities.\n\n"
                      "$prompt"
                      "After analyzing the assessment results, provide the response in the following format:\n\n"
                      "{\n   "
                      "  response: \"(Visual, Reading, Kinesthetic)\"\n"
                      "}"
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }


}