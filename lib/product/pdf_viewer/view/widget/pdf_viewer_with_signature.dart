import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'signature_view.dart';

class PdfViewerWithSignature extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerWithSignature({super.key, required this.pdfUrl});

  @override
  State<PdfViewerWithSignature> createState() => _PdfViewerWithSignatureState();
}

class _PdfViewerWithSignatureState extends State<PdfViewerWithSignature> {
  PdfControllerPinch? pdfController;
  bool isLoading = true;
  Uint8List? signatureBytes;
  int currentPage = 1;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp_document.pdf');
      await file.writeAsBytes(bytes);

      setState(() {
        pdfController = PdfControllerPinch(
          document: PdfDocument.openFile(file.path),
        );
        isLoading = false;
      });

      // Sayfa sayısını al
      final document = await PdfDocument.openFile(file.path);
      setState(() {
        totalPages = document.pagesCount;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF yüklenirken hata oluştu: $e')),
        );
      }
    }
  }

  Future<void> _getSignature() async {
    final signature = await showSignaturePopup(context);
    if (signature != null) {
      setState(() {
        signatureBytes = signature;
      });
    }
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Görüntüleyici'),
        actions: [
          if (pdfController != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: _getSignature,
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'İmza Al',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pdfController == null
          ? const Center(child: Text('PDF yüklenemedi'))
          : Stack(
              children: [
                PdfViewPinch(
                  controller: pdfController!,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                ),
                // İmza overlay - sadece son sayfada göster
                if (signatureBytes != null && currentPage == totalPages)
                  Positioned(
                    bottom: 40,
                    right: 40,
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          signatureBytes!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$currentPage / $totalPages',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
