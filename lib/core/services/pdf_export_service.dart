import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFExportService {
  PDFExportService._();
  static final instance = PDFExportService._();

  // ================================================================
  // ⭐ MAIN ENTRY: EXPORT FULL HIDDEN DASHBOARD AS MULTI-PAGE PDF
  // ================================================================
  Future<void> exportFullDashboard({
    required GlobalKey captureKey,
    required BuildContext context,
  }) async {
    try {
      _showLoader(context);

      // wait for hidden widget to fully render
      await Future.delayed(const Duration(milliseconds: 2000));

      final pngBytes = await _captureFullWidget(captureKey);
      if (pngBytes == null) throw "Failed to get bytes";

      await _createPdfFromFullImage(pngBytes);
    } catch (e, st) {
      log("PDF export failed: $e\n$st");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF generation failed: $e")),
        );
      }
    } finally {
      if (context.mounted) {
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }
  }

  // ================================================================
  // ⭐ CAPTURE WIDGET OFF-SCREEN
  // ================================================================
  Future<Uint8List?> _captureFullWidget(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      log("CAPTURE ERROR: $e");
      return null;
    }
  }

  // ================================================================
  // ⭐ CREATE MULTI-PAGE PDF FROM LARGE IMAGE
  // ================================================================
  Future<void> _createPdfFromFullImage(Uint8List pngBytes) async {
    final codec = await ui.instantiateImageCodec(pngBytes);
    final frame = await codec.getNextFrame();
    final ui.Image fullImg = frame.image;

    final pdf = pw.Document();

    final double pageW = PdfPageFormat.a4.width;
    final double pageH = PdfPageFormat.a4.height;

    final double imgW = fullImg.width.toDouble();
    final double imgH = fullImg.height.toDouble();

    final double scale = pageW / imgW;
    final double sliceH = pageH / scale;

    final int totalPages = (imgH / sliceH).ceil();

    for (int i = 0; i < totalPages; i++) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint();

      final double srcTop = i * sliceH;
      final double actualSliceH =
      (srcTop + sliceH > imgH) ? (imgH - srcTop) : sliceH;

      final src = Rect.fromLTWH(0, srcTop, imgW, actualSliceH);
      final dst = Rect.fromLTWH(0, 0, imgW, actualSliceH);

      canvas.drawImageRect(fullImg, src, dst, paint);

      final picture = recorder.endRecording();
      final ui.Image sliceImage = await picture.toImage(
        imgW.toInt(),
        actualSliceH.toInt(),
      );

      final sliceBytes = (await sliceImage.toByteData(
        format: ui.ImageByteFormat.png,
      ))!
          .buffer
          .asUint8List();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Image(
            pw.MemoryImage(sliceBytes),
            fit: pw.BoxFit.cover,
          ),
        ),
      );

      sliceImage.dispose();
    }

    fullImg.dispose();

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // ================================================================
  // ⭐ LOADING OVERLAY
  // ================================================================
  void _showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45), // Dimmed background
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          width: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Generating PDF...",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "This may take a few seconds",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
