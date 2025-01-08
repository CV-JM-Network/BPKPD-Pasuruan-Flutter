import 'package:bpkpd_pasuruan_app/screens/form_pengajuan.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/text_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api_service/api_service.dart';
import '../api_service/menu_permohonan/permohonan_request.dart';

class JenisPengajuan extends StatefulWidget {
  const JenisPengajuan({super.key, required this.username, this.idUser});
  final String username;
  final int? idUser;

  @override
  State<JenisPengajuan> createState() => _JenisPengajuanState();
}

class _JenisPengajuanState extends State<JenisPengajuan> {
  final ApiService apiService = ApiService();
  late Future<List<Permohonan>>? permohonanList;

  @override
  void initState() {
    super.initState();
    permohonanList = fetchPermohonanList();
  }

  Future<List<Permohonan>> fetchPermohonanList() async {
    final List<dynamic> data = await apiService.fetchData();
    return data.map((json) => Permohonan.fromJson(json)).toList();
  }

  Future<bool> requestStoragePermission(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final String userName = ModalRoute.of(context)?.settings.arguments as String? ?? "Guest";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/logo.png'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.menu_rounded),
          ),
        ],
        title: const Text("BPKPD Pasuruan"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
                text: "Welcome, ${widget.username}",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: width,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextWidget(
                text: "Menu Pengajuan",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
            const SizedBox(
              height: 15,
            ),
            FutureBuilder<List<Permohonan>>(
                future: permohonanList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No data found"));
                  } else {
                    final data = snapshot.data!;
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Jumlah kolom
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 4 / 6,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (await requestStoragePermission(
                                          Permission.storage) ==
                                      true) {
                                    print('Permission is granted');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FormPengajuan(
                                            idUser: widget.idUser,
                                            namaUser:
                                                widget.username.toString(),
                                            namaPermohonan: item.namaPermohonan,
                                            idUserPermohonan: item.id
                                                .toString()), // Kirim ID permohonan yang dipilih
                                      ),
                                    );
                                  } else {
                                    print('Permission is granted');
                                  }
                                },
                                child: Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Image.asset('assets/tax.png'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextWidget(
                                  text: item.namaPermohonan,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])
                              // Text(
                              //   item.namaPermohonan,
                              //   style: TextStyle(fontWeight: FontWeight.bold),
                              // ),
                            ],
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
