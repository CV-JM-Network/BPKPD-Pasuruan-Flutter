import 'dart:io';

import 'package:bpkpd_pasuruan_app/models/form-upload-model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DynamicFileUpload extends StatefulWidget {
  final List<FileUploadRequirement> requirements;
  final Function(Map<String, File>) onFilesSelected;
  final Function(bool)? onValidationChanged;

  const DynamicFileUpload({
    Key? key,
    required this.requirements,
    required this.onFilesSelected,
    this.onValidationChanged,
  }) : super(key: key);

  @override
  DynamicFileUploadState createState() => DynamicFileUploadState();
}

class DynamicFileUploadState extends State<DynamicFileUpload> {
  final Map<String, File> selectedFiles = {};

  Map<String, File> getSelectedFiles() => selectedFiles;

  bool validateFiles() {
    bool isValid = true;
    for (var req in widget.requirements) {
      if (req.wajib == "ya" && !selectedFiles.containsKey(req.syarat)) {
        isValid = false;
        break;
      }
    }
    widget.onValidationChanged?.call(isValid);
    return isValid;
  }

  void clearFiles() {
    setState(() {
      selectedFiles.clear();
      widget.onFilesSelected(selectedFiles);
    });
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

  Future<void> pickFile(String type, String syarat) async {
    // var status = await Permission.storage.request();
    if (await requestStoragePermission(Permission.storage) == true) {
      late FilePickerResult? result;

      switch (type) {
        case 'gambar':
          result = await FilePicker.platform.pickFiles(
            type: FileType.image,
          );
          break;
        case 'pdf':
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          break;
        case 'video':
          result = await FilePicker.platform.pickFiles(
            type: FileType.video,
          );
          break;
        default:
          result = await FilePicker.platform.pickFiles();
          break;
      }

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFiles[syarat] = File(result!.files.single.path!);
          widget.onFilesSelected(selectedFiles);
          validateFiles();
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Please grant storage permission to pick files'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.requirements.map((req) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: req.syarat,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (req.wajib == "ya")
                      const TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                tileColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  selectedFiles[req.syarat]?.path.split('/').last ??
                      'Pilih file ${req.tipe}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: () => pickFile(req.tipe, req.syarat),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
