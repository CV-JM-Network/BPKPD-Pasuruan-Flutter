import 'package:bpkpd_pasuruan_app/models/form-input-model.dart';
import 'package:flutter/material.dart';

class DynamicFormScreen extends StatefulWidget {
  final List<FormInput> formInputs;
  final ValueChanged<bool> onValidationChanged;

  const DynamicFormScreen({
    Key? key,
    required this.formInputs,
    required this.onValidationChanged,
  }) : super(key: key);

  @override
  DynamicFormScreenState createState() => DynamicFormScreenState();
}

class DynamicFormScreenState extends State<DynamicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  // Add methods to expose functionality
  bool validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    widget.onValidationChanged(isValid); // Trigger callback
    return isValid;
  }

  Map<String, dynamic> getFormData() {
    if (validateForm()) {
      _formKey.currentState?.save();
      return _formData;
    }
    return {};
  }

  // Expose form key
  GlobalKey<FormState> get formKey => _formKey;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildFormField(FormInput input) {
    switch (input.tipe) {
      case "text":
        return TextFormField(
          decoration: InputDecoration(
            labelText: input.judul,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSaved: (value) => _formData[input.judul] = value,
          validator: (value) {
            if (input.wajib == "ya" && (value == null || value.isEmpty)) {
              return '${input.judul} wajib diisi';
            }
            return null;
          },
        );

      case "angka":
        return TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: input.judul,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSaved: (value) => _formData[input.judul] = value,
          validator: (value) {
            if (input.wajib == "ya" && (value == null || value.isEmpty)) {
              return '${input.judul} wajib diisi';
            }
            if (value != null && int.tryParse(value) == null) {
              return 'Masukkan angka yang valid';
            }
            return null;
          },
        );

      case "select":
        final options = input.pilihan?.split(',') ?? [];
        print("PILIHAN: ${options}");
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: input.judul,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          value: _formData[input.judul],
          items: [
            for (String option in options)
              DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              )
          ],
          onChanged: (String? value) {
            setState(() {
              _formData[input.judul] = value;
            });
          },
          validator: (value) {
            if (input.wajib == "ya" && value == null) {
              return '${input.judul} wajib dipilih';
            }
            return null;
          },
        );

      case "radio":
        final options = input.pilihan?.split(',') ?? [];
        return FormField<String>(
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(input.judul),
                ...options.map((option) => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _formData[input.judul],
                      onChanged: (value) {
                        setState(() {
                          _formData[input.judul] = value;
                          state.didChange(value);
                        });
                      },
                    )),
              ],
            );
          },
        );

      case "checkbox":
        final options = input.pilihan?.split(',') ?? [];
        if (!_formData.containsKey(input.judul)) {
          _formData[input.judul] = <String>[];
        }
        return FormField<List<String>>(
          builder: (FormFieldState<List<String>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(input.judul),
                ...options.map((option) => CheckboxListTile(
                      title: Text(option),
                      value: (_formData[input.judul] as List<String>)
                          .contains(option),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked ?? false) {
                            (_formData[input.judul] as List<String>)
                                .add(option);
                          } else {
                            (_formData[input.judul] as List<String>)
                                .remove(option);
                          }
                          state.didChange(
                              _formData[input.judul] as List<String>);
                        });
                      },
                    )),
              ],
            );
          },
        );

      case "tanggal":
        return TextFormField(
          decoration: InputDecoration(
            labelText: input.judul,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                _formData[input.judul] =
                    "${picked.year}-${picked.month}-${picked.day}";
              });
            }
          },
          controller: TextEditingController(
              text: _formData[input.judul]?.toString() ?? ''),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ...widget.formInputs
              .map((input) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildFormField(input),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
