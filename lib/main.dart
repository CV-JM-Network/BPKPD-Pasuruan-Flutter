import 'package:bpkpd_pasuruan_app/screens/stack_login_register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/jenis_pengajuan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final lastLoginTime = prefs.getInt('last_login_time');
  final nama = prefs.getString('nama');
  final idUser = prefs.getInt('iduser');

  print("Nama: $nama");
  print("ID User: $idUser");
  print("Last Login Time: $lastLoginTime");

  bool isLoggedIn = false;

  if (lastLoginTime != null && nama != null && idUser != null) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    print("Current Time: $currentTime");

    if (currentTime - lastLoginTime <= 300000) {
      isLoggedIn = true;
      print("Session is valid");
    } else {
      print("Session has expired");
    }
  } else {
    print("No session data found");
  }

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    userName: nama ?? '',
    idUser: idUser ?? 0,
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.userName,
    this.idUser,
  });
  final bool isLoggedIn;
  final String? userName;
  final int? idUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn
    ? (userName != null && idUser != null
        ? JenisPengajuan(
            username: userName!,
            idUser: idUser!,
          )
        : const StackLoginRegister())
    : const StackLoginRegister(),
    );
  }
}
