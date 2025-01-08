import 'dart:convert';
import 'dart:io';

import 'package:bpkpd_pasuruan_app/models/form-input-model.dart';
import 'package:bpkpd_pasuruan_app/models/form-upload-model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'registrasi/confirmation_request.dart';
import 'registrasi/registration_response.dart';

class ApiService {
  static const String baseUrl = 'https://apibpkpd.jaylangkung.co.id/api/';
  final String apiKey = "7735676020";

  Future<http.Response> registerUser(String email, String password, String nama,
      String alamat, String telepon, String deviceToken) async {
    final url = Uri.parse('${baseUrl}user/registrasi');
    final requestBody = jsonEncode({
      'email': email,
      'password': password,
      'nama': nama,
      'alamat': alamat,
      'telpon': telepon,
      'device_token': deviceToken,
    });

    print('Request Body: $requestBody'); // Log the request body

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: requestBody,
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        print('Response Body: ${response.body}'); // Log the response body
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to register');
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
      'device_id': await getDeviceId(),
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

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${baseUrl}user/login');
    try {
      // Menyiapkan body untuk request
      final body = jsonEncode({
        'email': email,
        'password': password,
        // 'device_token': 'deviceId',
        'device_token': await getDeviceId(),
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
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final tokenAuth = jsonResponse['tokenAuth'];
        await saveAuthToken(tokenAuth);
        return json.decode(
            response.body); // Mengembalikan response body dalam bentuk Map
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}user/menu/pelayanan'),
        headers: {
          "Authorization": "Bearer $apiKey",
          // "Content-Type": "application/json",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        } else {
          throw Exception("API Error: ${jsonData['message']}");
        }
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Invalid API Key");
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to load data: $e");
    }
  }

  Future<Map<String, dynamic>> fetchFormData(String idUserPermohonan) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${baseUrl}user/get/form/syarat_dan_jenis?iduser_permohonan_setting=$idUserPermohonan'),
        headers: {
          "Authorization": "Bearer $apiKey",
          // "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Mengembalikan hasil response dalam bentuk Map
        return jsonDecode(response.body);
      } else {
        // Jika request gagal
        throw Exception('Failed to load form data');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load form data: $e');
    }
  }

  Future<Map<String, dynamic>> submitPermohonan({
    required String idUser,
    required String idSetting,
    required List<FormInput> formInput,
    required List<FileUploadRequirement> persyaratan,
    required String tahun,
    required List<File> files,
    required String token,
  }) async {
    try {
      final urlUploadFile = Uri.parse('${baseUrl}user/upload/file');

      for (var i = 0; i < files.length; i++) {
        final requestUploadFile = http.MultipartRequest('POST', urlUploadFile)
          ..fields['iduser'] = idUser
          ..files.add(await http.MultipartFile.fromPath('file', files[i].path))
          ..headers['Authorization'] = 'Bearer $apiKey';

        final responseUploadFile = await requestUploadFile.send();
        final responseBodyUploadFile =
            await responseUploadFile.stream.bytesToString();
        persyaratan[i].fileUrl = jsonDecode(responseBodyUploadFile)['file_url'];

        if (responseUploadFile.statusCode != 200) {
          throw Exception('Failed to upload file: ${responseBodyUploadFile}');
        }
      }

      final url = Uri.parse('${baseUrl}user/tambah/permohonan');

      print(
          "FORM-LIST: ${formInput.map((e) => e.toJson()).toList().toString()}");
      print(
          "SYARAT-LIST: ${persyaratan.map((e) => e.toJson()).toList().toString()}");

      final request = http.MultipartRequest('POST', url)
        ..fields['iduser'] = idUser
        ..fields['iduser_permohonan_setting'] = idSetting
        ..fields['form_input'] =
            jsonEncode(formInput.map((e) => e.toJson()).toList())
        ..fields['persyaratan'] =
            jsonEncode(persyaratan.map((e) => e.toJson()).toList())
        ..fields['tahun'] = tahun
        ..headers['Authorization'] = 'Bearer $apiKey';

      // Add files to the request
      // for (var entry in files.entries) {
      //   final multipartFile = await http.MultipartFile.fromPath(
      //       entry.key, entry.value);
      //   request.files.add(multipartFile);
      // }

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Log the response body for debugging
      print('Response Body: $responseBody');

      // Parse the response body
      final responseJson = jsonDecode(responseBody);
      print('Decoded JSON: $responseJson');

      // Check for status in the response
      if (responseJson['status'] == 'success') {
        // If success, return the data or success response
        return responseJson;
      } else {
        // If error, throw an exception with the error message
        throw Exception('Error: ${responseJson['message']}');
      }
    } catch (e) {
      // Catch any errors and throw an exception
      throw Exception('Error: $e');
    }
  }

  // Future<Map<String, dynamic>> submitPermohonan({
  //   required String idUser,
  //   required String idSetting,
  //   required List<Map<String, dynamic>> formInput,
  //   required List<Map<String, dynamic>> persyaratan,
  //   required String tahun,
  //   required Map<String, String> files,
  //   required String token,
  // }) async {
  //   try {
  //     final url = Uri.parse('${baseUrl}user/tambah/permohonan');
  //
  //     final request = http.MultipartRequest('POST', url)
  //       ..fields['iduser'] = idUser
  //       ..fields['iduser_permohonan_setting'] = idSetting
  //       ..fields['form_input'] = jsonEncode(formInput) // Ensure this is a valid JSON string
  //       ..fields['persyaratan'] = jsonEncode(persyaratan) // Ensure this is a valid JSON string
  //       ..fields['tahun'] = tahun
  //       ..headers['Authorization'] = 'Bearer $apiKey';
  //
  //     for (var entry in files.entries) {
  //       final multipartFile = await http.MultipartFile.fromPath(entry.key, entry.value);
  //       request.files.add(multipartFile);
  //     }
  //
  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();
  //     print('Syarat: ${persyaratan}');
  //     print('ForInput: ${formInput}');
  //
  //     if (response.statusCode == 200) {
  //       return jsonDecode(responseBody); // Parsing the response body to JSON
  //     } else {
  //       print('Error Response: $responseBody');
  //       throw Exception('Error with status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }
  Future<http.Response> uploadFile(int idUser, File file) async {
    final url =
        Uri.parse('https://apibpkpd.jaylangkung.co.id/api/user/upload/file');

    // Use MultipartRequest for form-data
    final request = http.MultipartRequest('POST', url);

    try {
      // Add the 'iduser' field
      request.fields['iduser'] = idUser.toString();

      // Add the file
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
      ));
      request.headers.addAll({
        'Authorization': 'Bearer $apiKey', // Example Authorization header
        'Content-Type': 'multipart/form-data', // Header for file upload
      });

      // Send request
      final streamedResponse = await request.send();

      // Convert StreamedResponse to Response
      final response = await http.Response.fromStream(streamedResponse);

      // Debug: Check response details
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to upload file');
    }
  }

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id ?? ''; // Use 'id' instead of 'androidId'
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? ''; // Unique ID on iOS
    }
    return '';
  }

  // Future<http.Response> forgotPassword(String email) async {
  //   final url = Uri.parse('${baseUrl}user/lupa/password');
  //   final deviceToken = await getDeviceId();
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'email': email,
  //         'device_token': 'deviceId',
  //         // 'device_token': deviceToken,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       return response;
  //     } else {
  //       throw Exception('Failed to send forgot password request');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to send forgot password request');
  //   }
  // }

  Future<http.Response> forgotPassword(String email) async {
    final url = Uri.parse('${baseUrl}user/lupa/password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'device_token': await getDeviceId()}),
      );
      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to send forgot password request');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to send verify code');
    }
  }

  Future<http.Response> verifyCode(String kodeLupaPassword) async {
    final url = Uri.parse('${baseUrl}user/lupa/password/memasukkan/kode');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'kode_lupa_password': kodeLupaPassword,
          'device_token': await getDeviceId(),
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to verify code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to verify code');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to verify code');
    }
  }

  Future<http.Response> changePassword(
      String email, String newPassword, String repeatPassword) async {
    final url = Uri.parse('${baseUrl}user/ganti/password');
    try {
      final body = jsonEncode({
        'email': email,
        'password': newPassword,
        'repeat_password': repeatPassword,
        'device_token': await getDeviceId(),
      });

// Cetak body JSON yang akan dikirim
      print("Request Body: $body");
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        final responseBody = jsonDecode(response.body);
        print('Failed to reset password: ${response.statusCode}');
        print('Response body: ${response.body}');

        throw Exception(
            'Failed to change password: ${responseBody['message']}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to change password');
    }
  }
}





//   Future<http.Response> uploadFile(int idUser, File file) async {
//     final url = Uri.parse('${baseUrl}user/upload/file');
//     final request = http.MultipartRequest('POST', url);
//
//     try {
//       // Tambahkan fields
//       request.fields['iduser'] = idUser.toString();
//
//       // Tambahkan file
//       request.files.add(await http.MultipartFile.fromPath('file', file.path));
//
//       // Tambahkan headers
//       request.headers.addAll({
//         'Authorization': 'Bearer $apiKey', // Contoh header Authorization
//         'Content-Type': 'multipart/form-data', // Header untuk file upload
//       });
//
//       // Kirim request
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       return response;
//     } catch (e) {
//       throw Exception('Gagal mengunggah file: $e');
//     }
//   }
// }

//   Future<Map<String, dynamic>> tambahPermohonan(
//       String idUser,
//       String idUserPermohonanSetting,
//       List<Map<String, dynamic>> persyaratan,
//       List<Map<String, dynamic>> formInput,
//       String tahun,
//       ) async {
//     // final String url = "$baseUrl/user/tambah/permohonan";
//
//     try {
//       // Prepare data untuk dikirim
//       final request = http.MultipartRequest('POST', Uri.parse('${baseUrl}user/tambah/permohonan') )
//         ..fields['iduser'] = idUser
//         ..fields['iduser_permohonan_setting'] = idUserPermohonanSetting
//         ..fields['persyaratan'] = jsonEncode(persyaratan)
//         ..fields['form_input'] = jsonEncode(formInput)
//         ..fields['tahun'] = tahun;
//
//       // Eksekusi request
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       // Parsing response JSON
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         return {
//           "status": "error",
//           "message": "Terjadi kesalahan: ${response.reasonPhrase}"
//         };
//       }
//     } catch (e) {
//       return {
//         "status": "error",
//         "message": "Terjadi kesalahan: $e"
//       };
//     }
//   }
// }

