import 'package:billing_0_0_3_/providers/sale_cart_provider.dart';
import 'package:billing_0_0_3_/providers/stock_provider.dart';
import 'package:billing_0_0_3_/screens/Purchase/purchase_item_confirm.dart';
import 'package:billing_0_0_3_/widgets/common/custom_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanResultDialog extends StatelessWidget {
  static const routeName = '/ScanResultDialog';
  final String barcode;
  final String event;
  ScanResultDialog(this.barcode, this.event);

  @override
  Widget build(BuildContext context) {
    var stockProvider = Provider.of<StockProvider>(context);
    stockProvider.search(cat: 'barcode', searchKey: barcode);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 100),
      child: ListView.builder(
          itemCount: stockProvider.items.length,
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                if (event == 'purchase')
                  Navigator.pushNamed(context, PurchaseItemConfirm.routeName,
                      arguments: stockProvider.items[index].id);
                if (event == 'sale')
                  Provider.of<SaleCartProvider>(context)
                      .addToCart(stockProvider.items[index].id);
              },
              child: CustomListItem(
                deleteFunction: null,
                editFunction: null,
                id: stockProvider.items[index].id,
                imageUrl: stockProvider.items[index].imageUrl,
                title: stockProvider.items[index].title,
                subtitle2: 'Package ${stockProvider.items[index].package}',
                subtitle1: stockProvider.items[index].company,
                subtitle3:
                    'Expiry Date:${stockProvider.items[index].exp.toString()}',
                subtitle4: 'Stock:${stockProvider.items[index].quantity}',
                trailing1: 'MRP:₹${stockProvider.items[index].mrp}',
                trailing2: 'Rate:₹${stockProvider.items[index].rate}',
                trailing3: 'PTR:₹${stockProvider.items[index].ptr}',
              ),
            );
          }),
    );
  }
}
