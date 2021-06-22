import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:billing_0_0_3_/providers/sale_cart_provider.dart';
import 'package:billing_0_0_3_/screens/sales/sale_search_screen.dart';
import 'package:billing_0_0_3_/widgets/sales/sale_summary_card.dart';
import 'package:billing_0_0_3_/widgets/common/drawer.dart';
import 'package:billing_0_0_3_/widgets/common/floating_button_animated.dart';
import 'package:billing_0_0_3_/widgets/common/small_widgets.dart';
import 'package:billing_0_0_3_/widgets/custom_list_item_inkwell.dart';
import 'package:billing_0_0_3_/widgets/purchase/barcode_scan_dialog_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SaleCartScreen extends StatelessWidget {
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
            return ScanResultDialog(barcode.rawContent, 'sale');
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
    var saleCart = Provider.of<SaleCartProvider>(context);
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
            Navigator.pushNamed(context, SaleSearchScreen.routeName);
          },
          mini: true,
          child: Icon(Icons.text_fields),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            
          }, icon:Icon(Icons.save))
        ],
      ),
      drawer: AppDrawerWidget(),
      body: Column(
        children: [
          if (saleCart.saleCartItems.length != 0) SaleSummaryCard(),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 80),
                itemCount: saleCart.saleCartItems.length,
                itemBuilder: (ctx, index) {
                  return CustomListItemWithInkWell(
                      bottomColor: Colors.black,
                      deleteFunction: () {
                        saleCart.deleteFromcart(saleCart.saleCartItems.values
                            .toList()[index]
                            .productId);
                      },
                      editFunction: null,
                      id: saleCart.saleCartItems.values
                          .toList()[index]
                          .productId,
                      imageUrl: saleCart.saleCartItems.values
                          .toList()[index]
                          .imageUrl,
                      title:
                          saleCart.saleCartItems.values.toList()[index].title,
                      subtitle1:
                          saleCart.saleCartItems.values.toList()[index].company,
                      subtitle2:
                          saleCart.saleCartItems.values.toList()[index].package,
                      subtitle3:
                          saleCart.saleCartItems.values.toList()[index].batch,
                      subtitle4: DateFormat.yMMM().format(
                          saleCart.saleCartItems.values.toList()[index].exp),
                      trailing1:
                          'MRP:₹${saleCart.saleCartItems.values.toList()[index].mrp.toStringAsFixed(2)}',
                      trailing2:
                          'PTR:₹${saleCart.saleCartItems.values.toList()[index].ptr.toStringAsFixed(2)}',
                      /* trailing3:
                          'Rate:₹${saleCart.saleCartItems.values.toList()[index].rate.toStringAsFixed(2)}', */
                      bottom1: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          textSpinBoxTogether(
                              min: 1,
                              value: 1,
                              text: 'Sale Quantity:',
                              onChange: (value) {
                                saleCart.updateQuantity(
                                    saleCart.saleCartItems.values
                                        .toList()[index]
                                        .productId,
                                    int.parse(value.toStringAsFixed(0)));
                              }),
                          textSpinBoxTogether(
                              text: 'Free:',
                              onChange: (value) {
                                //print(int.parse(value.toStringAsFixed(0)));
                                saleCart.updateFreeQuantity(
                                    saleCart.saleCartItems.values
                                        .toList()[index]
                                        .productId,
                                    int.parse(value.toStringAsFixed(0)));
                              }),
                          textSpinBoxTogether(
                              text: 'Discount:',
                              onChange: (value) {
                                //print(int.parse(value.toStringAsFixed(0)));
                                saleCart.updateDiscount(
                                    saleCart.saleCartItems.values
                                        .toList()[index]
                                        .productId,
                                    double.parse(value.toStringAsFixed(1)));
                              })
                        ],
                      ),
                      bottom2:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        textTogether(
                            'Amount:', '${saleCart.amountList[index]}'),
                        textTogether(
                            'Discount:', '${saleCart.discountList[index]}'),
                        textTogether('Taxable:',
                            ' ${saleCart.saleCartItems.values.toList()[index].taxable.toStringAsFixed(2)}'),
                        textTogether('GST:',
                            '${saleCart.saleCartItems.values.toList()[index].gstValue.toStringAsFixed(2)}'),
                        textTogether('Total:',
                            '${saleCart.saleCartItems.values.toList()[index].total.toStringAsFixed(2)}'),
                      ]));
                }),
          ),
        ],
      ),
      floatingActionButton: FancyFab(
        widget3: widget1(),
        widget2: widget2(),
        fabHeight: 52,
      ),
    );
  }
}
