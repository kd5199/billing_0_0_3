import 'package:billing_0_0_3_/providers/shop_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopDetailsScreen extends StatelessWidget {
  //const ShopDetails({ Key? key }) : super(key: key);
  static const routeName = '/ShopDetailsScreen';

  @override
  Widget build(BuildContext context) {
    Provider.of<ShopDetailsProvider>(context, listen: false).getData();
    var items = Provider.of<ShopDetailsProvider>(context, listen: false).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Details'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Text('Shop Name: ${items[0].title}'),
          Text('Address: ${items[0].address}'),
          Text('Contact No.: ${items[0].contact}'),
          Text('GSTIN: ${items[0].gstin}'),
          Text('DL No.: ${items[0].dlNo}'),
          Text('Financial Year: ${items[0].fYear}'),
        ],
      ),
    );
  }
}
