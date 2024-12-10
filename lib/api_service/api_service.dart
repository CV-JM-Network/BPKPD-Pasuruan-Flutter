import 'dart:convert';

import 'package:http/http.dart' as http;

import 'registrasi/confirmation_request.dart';
import 'registrasi/registration_request.dart';
import 'registrasi/registration_response.dart';

class ApiService {
  static const String baseUrl = 'https://apibpkpd.jaylangkung.co.id/api/';

  Future<RegistrationResponse> registerUser(RegistrationRequest request) async {
    final url = Uri.parse('${baseUrl}user/registrasi');
    final headers = {
      'Authorization': 'Bearer 7735676020',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return RegistrationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Registration failed: ${response.statusCode}');
    }
  }

  // Future<RegistrationResponse> confirmRegistration(
  //     ConfirmationRequest request) async {
  //   final url = Uri.parse('${baseUrl}user/registrasi/konfirmasi');
  //   final headers = {
  //     'Authorization': 'Bearer 7735676020',
  //   };

  //   final body = {
  //     // 'kode_konfirmasi': "1234",
  //     'kode_konfirmasi': request.kodeKonfirmasi,
  //     'device_id': request.deviceId,
  //   };

  //   final response =
  //       await http.post(url, headers: headers, body: jsonEncode(body));

  //   if (response.statusCode == 201) {
  //     return RegistrationResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Confirmation failed: ${response.statusCode}');
  //   }
  // }

  Future<RegistrationResponse> confirmRegistration(
      ConfirmationRequest request) async {
    final url = Uri.parse('${baseUrl}user/registrasi/konfirmasi');
    final headers = {
      'Authorization': 'Bearer 7735676020',
      'Content-Type': 'application/json',
    };

    final body = {
      'kode_konfirmasi': request.kodeKonfirmasi,
      'device_id': 'deviceId',
    };

    print("Request body: ${jsonEncode(body)}");

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      return RegistrationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Confirmation failed: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> login(
      String email, String password, String deviceToken) async {
    final url = Uri.parse('${baseUrl}user/login');
    try {
      // Menyiapkan body untuk request
      final body = jsonEncode({
        'email': email,
        'password': password,
        'device_token': deviceToken,
      });

      // Menambahkan log untuk melihat request
      print("Request URL: $url");
      print("Request body: $body");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer 7735676020', // API Key di header
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Menambahkan log untuk melihat response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Mengecek status code dan parsing response
      if (response.statusCode == 200) {
        return json.decode(
            response.body); // Mengembalikan response body dalam bentuk Map
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
