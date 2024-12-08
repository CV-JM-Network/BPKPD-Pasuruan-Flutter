class RegistrationRequest {
  final String email;
  final String password;
  final String nama;
  final String alamat;
  final String telpon;
  final String deviceToken;

  RegistrationRequest({
    required this.email,
    required this.password,
    required this.nama,
    required this.alamat,
    required this.telpon,
    required this.deviceToken,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'nama': nama,
        'alamat': alamat,
        'telpon': telpon,
        'device_token': deviceToken,
      };
}
