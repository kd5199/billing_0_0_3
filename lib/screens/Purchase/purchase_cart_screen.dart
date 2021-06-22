import 'dart:io';
import '../../screens/Purchase/purchase_confirm_screen.dart';
import '../../widgets/common/small_widgets.dart';
import '../../widgets/custom_list_item_inkwell.dart';
import '../../widgets/purchase/barcode_scan_dialog_suggestion.dart';
import '../../widgets/purchase/purchase_confirm_cart.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../../providers/purchase_cart_provider.dart';
import '../../screens/Purchase/purchase_search.dart';
import '../../widgets/common/drawer.dart';
import '../../widgets/common/floating_button_animated.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class PurchaseCart extends StatefulWidget {
  static const routeName = '/PurchaseCart';

  @override
  _PurchaseCartState createState() => _PurchaseCartState();
}

class _PurchaseCartState extends State<PurchaseCart> {
  //ScrollController controller;

  bool scanned = false;

  var barcode;

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

  @override
  Widget build(BuildContext context) {
    Widget widget1() {
      return Container(
        child: FloatingActionButton(
          mini: true,
          heroTag: null,
          onPressed: () {
            barcodeScanning(context);
          },
          child: Icon(Icons.qr_code),
        ),
      );
    }

    Widget widget2() {
      return Container(
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            Navigator.pushNamed(context, PurchaseSearchScreen.routeName);
          },
          mini: true,
          child: Icon(Icons.text_fields),
        ),
      );
    }

    var purchaseCart = Provider.of<PurchaseCartProvider>(context);

    return Scaffold(
        //floatingActionButtonLocation: FloatingActionButtonLocation,
        drawer: AppDrawerWidget(),
        appBar: AppBar(
          actions: [
            if (purchaseCart.cartItems.length != 0)
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return PurchaseConfirm();
                        });
                    //Navigator.pushNamed(context, PurchaseConfirm.routeName);
                  },
                  icon: Icon(Icons.save))
          ],
          title: Text('Purchase'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            if (purchaseCart.cartItems.length != 0) PurchaseSummeryCard(),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  itemCount: purchaseCart.cartItems.length,
                  itemBuilder: (ctx, index) {
                    return CustomListItemWithInkWell(
                        bottomColor: Colors.black,
                        deleteFunction: () {
                          purchaseCart.deleteFromcart(purchaseCart
                              .cartItems.values
                              .toList()[index]
                              .productId);
                        },
                        editFunction: null,
                        id: purchaseCart.cartItems.values
                            .toList()[index]
                            .productId,
                        imageUrl: File(purchaseCart.cartItems.values
                            .toList()[index]
                            .imageUrl),
                        title:
                            purchaseCart.cartItems.values.toList()[index].title,
                        subtitle1: purchaseCart.cartItems.values
                            .toList()[index]
                            .company,
                        subtitle2: purchaseCart.cartItems.values
                            .toList()[index]
                            .package,
                        subtitle3:
                            purchaseCart.cartItems.values.toList()[index].batch,
                        subtitle4: DateFormat.yMMM().format(
                            purchaseCart.cartItems.values.toList()[index].exp),
                        trailing1:
                            'MRP:₹${purchaseCart.cartItems.values.toList()[index].mrp.toStringAsFixed(2)}',
                        trailing2:
                            'PTR:₹${purchaseCart.cartItems.values.toList()[index].ptr.toStringAsFixed(2)}',
                        trailing3:
                            'Rate:₹${purchaseCart.cartItems.values.toList()[index].rate.toStringAsFixed(2)}',
                        bottom1: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            textSpinBoxTogether(
                                min: 1,
                                value: 1,
                                text: 'Purchase Quantity:',
                                onChange: (value) {
                                  purchaseCart.updateQuantity(
                                      purchaseCart.cartItems.values
                                          .toList()[index]
                                          .productId,
                                      int.parse(value.toStringAsFixed(0)));
                                }),
                            textSpinBoxTogether(
                                text: 'Free:',
                                onChange: (value) {
                                  //print(int.parse(value.toStringAsFixed(0)));
                                  purchaseCart.updateFreeQuantity(
                                      purchaseCart.cartItems.values
                                          .toList()[index]
                                          .productId,
                                      int.parse(value.toStringAsFixed(0)));
                                }),
                            textSpinBoxTogether(
                                text: 'Discount:',
                                onChange: (value) {
                                  //print(int.parse(value.toStringAsFixed(0)));
                                  purchaseCart.updateDiscount(
                                      purchaseCart.cartItems.values
                                          .toList()[index]
                                          .productId,
                                      double.parse(value.toStringAsFixed(1)));
                                })
                          ],
                        ),
                        bottom2:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          textTogether(
                              'Amount:', '${purchaseCart.amountList[index]}'),
                          textTogether('Discount:',
                              '${purchaseCart.discountList[index]}'),
                          textTogether('Taxable:',
                              ' ${purchaseCart.cartItems.values.toList()[index].taxable.toStringAsFixed(2)}'),
                          textTogether('GST:',
                              '${purchaseCart.cartItems.values.toList()[index].gstValue.toStringAsFixed(2)}'),
                          textTogether('Total:',
                              '${purchaseCart.cartItems.values.toList()[index].total.toStringAsFixed(2)}'),
                        ]));
                  }),
            ),
          ],
        ),
        floatingActionButton: FancyFab(
          widget3: widget1(),
          widget2: widget2(),
          fabHeight: 52,
        ));
  }
}
