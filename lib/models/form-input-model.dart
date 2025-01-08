class FormInput {
  dynamic idformInput;
  String tipe;
  String judul;
  dynamic pilihan;
  String wajib;
  dynamic isi;

  FormInput({
    this.idformInput,
    required this.tipe,
    required this.judul,
    this.pilihan,
    required this.wajib,
    this.isi,
  });

  factory FormInput.fromJson(Map<String, dynamic> json) {
    return FormInput(
      idformInput: json['idform_input'],
      tipe: json['tipe'],
      judul: json['judul'],
      pilihan: json['pilihan'],
      wajib: json['wajib'],
      isi: json['isi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idform_input': idformInput,
      'tipe': tipe,
      'judul': judul,
      'pilihan': pilihan,
      'wajib': wajib,
      'isi': isi,
    };
  }
}
