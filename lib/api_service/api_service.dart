import 'dart:convert';

import 'package:email_otp/email_otp.dart';
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
      try {
        await EmailOTP.sendOTP(email: request.email);
      } catch (e) {
        print('Failed to send OTP: $e');
        // Handle email sending error (e.g., display an error message to the user)
      }

      return RegistrationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Registration failed: ${response.statusCode}');
    }
  }

  Future<RegistrationResponse> confirmRegistration(
      ConfirmationRequest request) async {
    final url = Uri.parse('${baseUrl}user/registrasi/konfirmasi');
    final headers = {
      'Authorization': 'Bearer 7735676020',
    };

    final body = {
      'kode_konfirmasi': request.kodeKonfirmasi,
      'device_id': request.deviceId,
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 201) {
      return RegistrationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Confirmation failed: ${response.statusCode}');
    }
  }
}
