import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateOfBirthWidget extends StatefulWidget {
  const DateOfBirthWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DateOfBirthWidgetState createState() => _DateOfBirthWidgetState();
}

class _DateOfBirthWidgetState extends State<DateOfBirthWidget> {
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final dob = _dobController.text.trim();

    // Doğum tarihi formatı (gg/aa/yyyy)
    if (dob.isEmpty || !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dob)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir doğum tarihi girin (gg/aa/yyyy).'),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Doğum tarihi doğrulandı.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doğum Tarihi Girişi")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _dobController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),

                _DateFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Doğum Tarihi (gg/aa/yyyy)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _onSubmit(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Giriş Yap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > oldValue.text.length) {
      String newText = newValue.text;

      if (newText.length == 2 || newText.length == 5) {
        newText = '$newText/'; // "/" karakterini ekle
      }

      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}
