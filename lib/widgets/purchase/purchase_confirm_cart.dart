import 'package:billing_0_0_3_/providers/purchase_cart_provider.dart';
import 'package:billing_0_0_3_/widgets/common/small_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseSummeryCard extends StatefulWidget {
  //const PurchaseSummeryCard({ Key? key }) : super(key: key);
  @override
  _PurchaseSummeryCardState createState() => _PurchaseSummeryCardState();
}

class _PurchaseSummeryCardState extends State<PurchaseSummeryCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    var purchaseprovider = Provider.of<PurchaseCartProvider>(context);
    return InkWell(
        onTap: () {
          setState(() {
            selected = !selected;
          });
        },
        child: AnimatedContainer(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  textTogether('Grand Total:',
                      '${purchaseprovider.grandTotal.toStringAsFixed(2)}',
                      font1: 20, font2: 20),
                  SizedBox(
                    height: 10,
                  ),
                  //if (selected)
                  textTogether('Total Amount:',
                      '${purchaseprovider.totalAmount.toStringAsFixed(2)}'),
                  //if (selected)
                  textTogether('Total Discount:',
                      '${purchaseprovider.totalDiscount.toStringAsFixed(2)}'),
                  //if (selected)
                  textTogether('Total Taxable:',
                      '${purchaseprovider.totalTaxable.toStringAsFixed(2)}'),
                  //if (selected)
                  textTogether('Total GST:',
                      '${purchaseprovider.totalGstValue.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: selected ? Colors.amber.shade100 : Colors.amberAccent,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          width: double.infinity,
          height: selected ? 120 : 50,
          alignment: Alignment.topCenter,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutCubic,
        ));
  }
}
