class LoginRequest {
  final String email;
  final String password;
  final String deviceToken;

  LoginRequest({
    required this.email,
    required this.password,
    required this.deviceToken,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'device_token': deviceToken,
      };
}
