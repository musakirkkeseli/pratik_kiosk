import 'package:flutter/material.dart';
import '../pdf_viewer_with_signature.dart';

class PdfTestButton extends StatelessWidget {
  const PdfTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PdfViewerWithSignature(
              pdfUrl: 'https://dokuman.osym.gov.tr/pdfdokuman/2025/YKS/TSK/yks_tyt_2025_kitapcik_d250.pdf',
            ),
          ),
        );
      },
      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
      label: const Text(
        'PDF Aç',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}
