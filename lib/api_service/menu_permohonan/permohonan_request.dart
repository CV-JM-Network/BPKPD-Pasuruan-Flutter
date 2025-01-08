class Permohonan {
  final int id;
  final String namaPermohonan;

  Permohonan({
    required this.id,
    required this.namaPermohonan,
  });

  factory Permohonan.fromJson(Map<String, dynamic> json) {
    return Permohonan(
      id: json['iduser_permohonan_setting'],
      namaPermohonan: json['nama_permohonan'],
    );
  }
}
