import 'package:barcode_scan/barcode_scan.dart';
import 'package:billing_0_0_3_/widgets/purchase/barcode_scan_dialog_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

Widget textTogether(String key, String value,
    {double font1 = 14, double font2 = 14}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        key,
        style: TextStyle(fontSize: font1),
      ),
      Text(
        value,
        style: TextStyle(fontSize: font2),
      ),
    ],
  );
}

Widget textSpinBoxTogether(
    {String text, Function onChange, int min = 0, int value = 0}) {
  return SizedBox(
    height: 30,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(text)),
        Expanded(
          child: SpinBox(
              textAlign: TextAlign.center,
              decoration:
                  InputDecoration(isDense: true, border: InputBorder.none),
              min: min.toDouble(),
              value: value.toDouble(),
              onChanged: onChange),
        ),
      ],
    ),
  );
}

Widget IconButtonWithText({IconData icon, String text, Function onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon), Text(text)],
    ),
  );
}
/* class helpers{
Future barcodeScanning(BuildContext context) async {
    try {
      barcode = await BarcodeScanner.scan();
      scanned = true;
      this.barcode = barcode;
      showDialog(
          context: context,
          builder: (_) {
            return ScanResultDialog(barcode.rawContent, 'purchase');
          });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        this.barcode = 'No camera permission!';
      } else {
        this.barcode = 'Unknown error: $e';
      }
    } on FormatException {
      this.barcode = 'Nothing captured.';
    } catch (e) {
      this.barcode = 'Unknown error: $e';
    }
  }
Widget widget1() {
      return Container(
        child: FloatingActionButton(
          mini: true,
          heroTag: null,
          onPressed: () {
            barcodeScanning(BuildContext context);
          },
          child: Icon(Icons.qr_code),
        ),
      );
    }
} */