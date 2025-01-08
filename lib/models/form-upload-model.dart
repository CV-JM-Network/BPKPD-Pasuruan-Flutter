class FileUploadRequirement {
  int idsyarat;
  String syarat;
  String tipe;
  String wajib;
  String? fileName;
  String? fileUrl;
  

  FileUploadRequirement({
    required this.idsyarat,
    required this.syarat,
    required this.tipe,
    required this.wajib,
    this.fileName,
    this.fileUrl,
  });

  factory FileUploadRequirement.fromJson(Map<String, dynamic> json) {
    return FileUploadRequirement(
      idsyarat: json['idsyarat'],
      syarat: json['syarat'],
      tipe: json['tipe'],
      wajib: json['wajib'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idsyarat': idsyarat,
      'syarat': syarat,
      'tipe': tipe,
      'wajib': wajib,
      'fileName': fileName,
      'fileUrl': fileUrl,
    };
  }
}
