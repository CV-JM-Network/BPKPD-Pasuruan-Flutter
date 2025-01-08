import 'dart:convert';
import 'dart:io';

import 'package:bpkpd_pasuruan_app/models/form-input-model.dart';
import 'package:bpkpd_pasuruan_app/models/form-upload-model.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/text_widget.dart';
import 'package:bpkpd_pasuruan_app/widgets/dynamic-form-input.dart';
import 'package:bpkpd_pasuruan_app/widgets/dynamic-form-upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../api_service/api_service.dart';

class FormPengajuan extends StatefulWidget {
  const FormPengajuan({
    super.key,
    required this.idUserPermohonan,
    this.namaPermohonan,
    this.namaUser,
    this.idUser,
  });

  final String idUserPermohonan;
  final String? namaPermohonan;
  final String? namaUser;
  final int? idUser;

  @override
  State<FormPengajuan> createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  late Future<Map<String, dynamic>> formData;
  final _inputController = TextEditingController();
  final _namaController = TextEditingController();
  final ApiService apiService = ApiService();
  File? selectedFile;
  bool _isUploading = false;

  late List<TextEditingController> _controllers = [];
  late List<FormInput> formInput = [];
  final _formScreenKey = GlobalKey<DynamicFormScreenState>();
  final _uploadKey = GlobalKey<DynamicFileUploadState>();

  Map<String, String> selectedFiles = {};

  setControllers() {
    _controllers =
        List.generate(formInput.length, (index) => TextEditingController());
  }

  Future<String?> pickFile(String allowedExtensions, String key) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions.split(','),
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFiles[key] = file.path ?? ''; // Save file path
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected.')),
      );
    }
  }

  Future<void> _submitForm(List<String> tipeInputs, List<String> juduls,
      List<String> wajibs, List<String> tipeSyars,
      {List<FormInput>? formInputValue}) async {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    try {
      // formInput = [
      //   {
      //     "idform_input": 0,
      //     "tipe": tipeInputs,
      //     "judul": juduls,
      //     "isi": _controllers,
      //     "wajib": wajibs,
      //   },
      // ];

      // Debugging untuk memastikan hasilnya
      print("Form Input Final: $formInput");

      final List<FileUploadRequirement> persyaratan = [];
      int idSyaratCounter = 0; // Counter for idsyarat

      for (var entry in selectedFiles.entries) {
        // Upload each file
        File file = File(entry.value);

        final uploadResponse =
            await apiService.uploadFile(widget.idUser!, file);
        final responseBody = jsonDecode(uploadResponse.body);

        final fileName = responseBody['file_name'];
        final FILE_URL = responseBody['file_url'];

        if (uploadResponse.statusCode == 200) {
          final fileNameEncoded =
              Uri.encodeFull(fileName); // URL-encode the file name
          final uploadedFileUrl = "../../source/2/file_syarat/$fileNameEncoded";
          // final uploadedFileUrl = "source/2/file_syarat/${fileName}"; // Assuming this is the file URL

          // Ensure you are setting the correct values for each entry
          // persyaratan.add({
          //   "idsyarat": idSyaratCounter++, // Incrementing ID for each item
          //   "syarat": entry.key, // The name of the requirement (e.g., "KTP", "KK")
          //   "tipe": tipeSyars, // Type of file (adjust this if needed)
          //   "fileName": fileName, // Extract the file name from path
          //   "fileUrl":
          //       uploadedFileUrl, // Assuming uploadedFileUrl is correct and in the format expected
          // });
          print('File Path: ${file.path}');
          print('Key: ${entry.key}');
          print('File Nae: ${fileName}');
          print('File URL: ${FILE_URL}');
          print('Data Fields: $persyaratan');
          print('Generated file URL: $uploadedFileUrl');

          print(
              'Response for ${entry.key}: ${uploadResponse.statusCode}, Body: ${uploadResponse.body}');
        } else {
          throw Exception(
              'Failed to upload file: ${entry.key}, Response: ${uploadResponse.body}');
        }
      }

      print("Persyaratan data being sent: ${jsonEncode(persyaratan)}");

      // Debug: print the persyaratan data after file uploads
      print("Persyaratan data after uploads: $persyaratan");
      print("Formmm: $formInput");
      // Submit form data
      final response = await apiService.submitPermohonan(
        idUser: widget.idUser.toString(),
        idSetting: widget.idUserPermohonan.toString(),
        formInput: formInput,
        persyaratan: persyaratan,
        tahun: '2023',
        files: [],
        token: '7735676020',
      );
      if (response['status'] == 'success') {
        print("Response: ${response.toString()}"); // Debugging response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dikirim!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future submitFormX(
      {List<FormInput>? formInputValue,
      List<FileUploadRequirement>? fileUploadValue,
      List<File>? filex}) async {
    try {
      final response = await apiService.submitPermohonan(
        idUser: widget.idUser.toString(),
        idSetting: widget.idUserPermohonan.toString(),
        formInput: formInputValue!,
        persyaratan: fileUploadValue!,
        tahun: '2024',
        files: filex!,
        token: '7735676020',
      );
      if (response['status'] == 'success') {
        print("Response: ${response.toString()}"); // Debugging response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dikirim!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  getFormData() {
    final response = apiService.fetchFormData(widget.idUserPermohonan);
    setState(() {
      formData = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getFormData();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  TextInputType? _getKeyboardType(String tipe) {
    switch (tipe) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      default:
        return TextInputType.text; // Default type
    }
  }

  bool isFormValid = false;
  bool isFilesValid = false;

  // Ensure button is enabled/disabled based on form and file validity
  bool get isButtonEnabled => isFormValid && isFilesValid;

  void checkButtonState() {
    bool formValid = _formScreenKey.currentState?.validateForm() ?? false;
    bool filesValid = _uploadKey.currentState?.validateFiles() ?? false;

    // Update only if there is a change in validity state
    if (formValid != isFormValid || filesValid != isFilesValid) {
      setState(() {
        isFormValid = formValid;
        isFilesValid = filesValid;
      });
      print('Form Valid: $isFormValid, Files Valid: $isFilesValid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Form Permohonan"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<Map<String, dynamic>>(
        future: formData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!['status'] != 'success') {
            return const Center(child: Text('No data found'));
          } else {
            // print("FORM-DATA: ${jsonEncode(snapshot.data!['data'])}");
            final formData = snapshot.data!['data'][0];
            List<dynamic> formInputs = jsonDecode(formData['form_input']);
            for (var i = 0; i < formInputs.length; i++) {
              _controllers.add(TextEditingController());
            }
            // print("Form-Inputs: ${jsonEncode("${formInputs}")}");

            List<FormInput> formInputX =
                formInputs.map((input) => FormInput.fromJson(input)).toList();
            // formInputX.add(FormInput.fromJson({
            //   "idform_input": "2",
            //   "tipe": "select",
            //   "judul": "Kendaraan",
            //   "pilihan": "Mobil,Motor",
            //   "wajib": "tidak"
            // }));
            List<dynamic> syarat = jsonDecode(formData['syarat']);
            List<FileUploadRequirement> fileUploadRequirements = syarat
                .map((syarat) => FileUploadRequirement.fromJson(syarat))
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: "Form Permohonan ${widget.namaPermohonan}",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 25),
                  DynamicFormScreen(
                      key: _formScreenKey,
                      formInputs: formInputX,
                      onValidationChanged: (isValid) {
                        if (isValid != isFormValid) {
                          setState(() {
                            isFormValid = isValid;
                          });
                          checkButtonState(); // Call checkButtonState only when the form validity changes
                        }
                        print("Form Valid: $isValid");
                      }),
                  DynamicFileUpload(
                    key: _uploadKey,
                    requirements: fileUploadRequirements,
                    onFilesSelected: (files) {
                      // Handle selected files
                      print(files);
                    },
                    onValidationChanged: (isValid) {
                      // Update the files validity when validation changes
                      if (isValid != isFilesValid) {
                        setState(() {
                          isFilesValid = isValid;
                        });
                        checkButtonState(); // Call checkButtonState only when the file validity changes
                      }
                      print("Files Valid: $isValid");
                    },
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isButtonEnabled
                          ? () async {
                              if (_formScreenKey.currentState?.validateForm() ??
                                  false) {
                                final formData =
                                    _formScreenKey.currentState?.getFormData();
                                // Handle form data
                                print("JOKOWI: ${formData}");
                              }

                              if (_uploadKey.currentState?.validateFiles() ??
                                  false) {
                                final files =
                                    _uploadKey.currentState?.getSelectedFiles();
                                // Process files
                                print("JOKOWIZ: ${files}");
                              }

                              formInputX.asMap().forEach((index, formInput) {
                                if (formInput.tipe == 'checkbox') {
                                  formInput.isi = _formScreenKey.currentState
                                                  ?.getFormData()[
                                              formInput.judul] !=
                                          null
                                      ? _formScreenKey.currentState
                                          ?.getFormData()[formInput.judul]
                                          .join(",")
                                      : '';
                                } else {
                                  formInput.isi = _formScreenKey.currentState
                                          ?.getFormData()[formInput.judul] ??
                                      '';
                                }
                              });

                              fileUploadRequirements
                                  .asMap()
                                  .forEach((index, formInput) {
                                File? file = _uploadKey.currentState
                                    ?.getSelectedFiles()[formInput.syarat];
                                if (file != null) {
                                  formInput.fileName =
                                      file.path.split('/').last;
                                } else {
                                  formInput.fileName = '';
                                }
                              });

                              print(
                                  "FILE-UPLOAD: ${fileUploadRequirements.map((e) => e.toJson()).toList()}");

                              List<File> files = _uploadKey.currentState
                                      ?.getSelectedFiles()
                                      .values
                                      .map((e) => File(e.path))
                                      .toList() ??
                                  [];
                              print("FILES: $files");

                              await submitFormX(
                                  formInputValue: formInputX,
                                  fileUploadValue: fileUploadRequirements,
                                  filex: files);
                            }
                          : null,
                      child: Text(
                        'Custom Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
