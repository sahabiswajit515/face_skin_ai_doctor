import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class GeminiService {
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent";

  Future<Map<String, dynamic>> analyzeSkin(String imagePath) async {
    final File imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      return {'error': 'Image file not found.'};
    }

    try {
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text": """
                You are a professional dermatologist. Analyze the provided face/skin image.
                Provide the analysis in JSON format ONLY. 
                Do NOT include any brand names.
                Use generic medicine compositions only.
                If the image is not a face or skin image, or too far away, blurry, return an error message in JSON.

                JSON Format:
                {
                  "skin_type": "string (oily, dry, normal, combination, sensitive)",
                  "detected_issues": ["list of strings"],
                  "beauty_tips": ["list of 1-3 strings"],
                  "home_remedies": ["list of strings"],
                  "medicine_suggestions": ["list of generic compositions"],
                  "overall_assessment": "string"
                }

                In case of non-skin/face image:
                {
                  "error": "Sorry, out of context/blurry/too far. I am a Face & Skin AI Doctor only. Please send a proper close-up face or skin condition photograph to analyze."
                }
                """
              },
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image
                }
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.2,
          "response_mime_type": "application/json",
        }
      };

      final response = await http.post(
        Uri.parse("$_baseUrl?key=${ApiConfig.geminiApiKey}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String textResponse = data['candidates'][0]['content']['parts'][0]['text'];
        return jsonDecode(textResponse);
      } else if (response.statusCode == 401) {
        return {'error': 'Invalid API Key. Please check your configuration.'};
      } else if (response.statusCode == 429) {
        return {'error': 'Rate limit exceeded. Please try again later.'};
      } else {
        return {'error': 'Server error: ${response.statusCode}'};
      }
    } on SocketException {
      return {'error': 'Network error. Please check your internet connection.'};
    } on FormatException {
      return {'error': 'Invalid response from AI doctor.'};
    } catch (e) {
      return {'error': 'An unexpected error occurred: $e'};
    }
  }
}
