import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

Future<Uint8List?> showSignaturePopup(BuildContext context) async {
  final SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  return await showDialog<Uint8List?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text(
        "İmzanızı Atınız",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 600,
        height: 300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200]!,
            border: Border.all(color: Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: controller,
            backgroundColor: Colors.grey[200]!,
          ),
        ),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            controller.clear();
          },
          icon: const Icon(Icons.clear, color: Colors.red),
          label: const Text(
            "Temizle",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            if (controller.isNotEmpty) {
              final signature = await controller.toPngBytes();
              Navigator.of(context).pop(signature);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lütfen önce imza atınız')),
              );
            }
          },
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text(
            "Kaydet",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: Colors.green,
          ),
        ),
      ],
    ),
  );
}
