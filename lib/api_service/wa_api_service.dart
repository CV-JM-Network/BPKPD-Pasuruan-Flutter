import 'dart:convert';

import 'package:http/http.dart' as http;

class OCAWaApiService {
  final String baseUrl = "https://wa01.ocatelkom.co.id/api/v2";
  final String token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
      "U1ME-Z74bF6uJISJjSXpR-zydb7rNlurVE7d4SWtoqBWZAkRqcm6soh74lGpnVTKwXhf5zpQXtN6PmBHanc2w9RrF2_6i0UyM-DnlqHPswmvbIFWwKNVjcWilU1_W9v-UDj8xVrPaGHOoa303kethPclLfk9aLblCMg77xSxXnX2tGUy9tenkgo3Fi8tbpKXCGt8Jn3DSbZ6189yWP6Gp8mLC6uZM2KoPIXGeLFm5jDdBY3ZMzsp0YA7sUrLL-7tAESIq0CBGBuuL54qv57KKrHzRzhyIKdib618x-2LDcLUHHXQYd2rZOqpD_Y6-nNYeqVkbHA_yP-zWKXnhhoSyw";

  // Fungsi untuk mengirim pesan WhatsApp
  Future<void> sendMessage({
    required String phoneNumber,
    required String templateCodeId,
    required String name,
  }) async {
    final url = Uri.parse("$baseUrl/push/message");
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = {
      "phone_number": phoneNumber,
      "message": {
        "type": "template",
        "template": {
          "template_code_id": templateCodeId,
          "payload": [
            {
              "position": "body",
              "parameters": [
                {
                  "type": "text",
                  "text": name,
                }
              ]
            }
          ]
        }
      }
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Message sent successfully!");
    } else {
      print(
          "Failed to send message: ${response.statusCode} - ${response.body}");
      throw Exception("Error sending message: ${response.body}");
    }
  }

  // Fungsi untuk mengecek status pesan
  Future<void> checkMessageStatus({required String messageId}) async {
    final url = Uri.parse("$baseUrl/message/$messageId/status");
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Message status: ${data['status']}");
    } else {
      print("Failed to fetch message status: ${response.statusCode}");
      throw Exception("Error fetching status: ${response.body}");
    }
  }
}
