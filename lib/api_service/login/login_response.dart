class LoginResponse {
  final String status;
  final String message;
  final Data? data;
  final String tokenAuth;

  LoginResponse(
      {required this.status,
      required this.message,
      this.data,
      required this.tokenAuth});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      tokenAuth: json['tokenAuth'],
    );
  }
}

class Data {
  final int iduser;
  final String email;
  final String nama;
  final String alamat;
  final String telpon;
  final String? img;
  final String deviceToken;

  Data({
    required this.iduser,
    required this.email,
    required this.nama,
    required this.alamat,
    required this.telpon,
    this.img,
    required this.deviceToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      iduser: json['iduser'],
      email: json['email'],
      nama: json['nama'],
      alamat: json['alamat'],
      telpon: json['telpon'],
      img: json['img'],
      deviceToken: json['device_token'],
    );
  }
}
