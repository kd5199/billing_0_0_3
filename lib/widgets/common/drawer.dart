import 'package:billing_0_0_3_/screens/Others/intro_screen.dart';
import 'package:billing_0_0_3_/screens/Others/shop_details_screen.dart';
import 'package:billing_0_0_3_/screens/Others/suppliers_screen.dart';
import 'package:billing_0_0_3_/widgets/common/shop_details_input.dart';
import 'package:flutter/material.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Drawer(
      elevation: 20,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: deviceSize.height / 4,
            color: Colors.blue.shade100,
          ),
          ListTile(
            leading: Icon(Icons.fiber_new_sharp),
            title: Text('New Financial Year'),
            onTap: () {
              Navigator.of(context).pushNamed(OnBoardingPage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text('Take Backup'),
            onTap: () {
              //Navigator.of(context).pushNamed(SaleScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description_sharp),
            title: Text('Shop Details'),
            onTap: () {
              Navigator.pushNamed(context, ShopDetailsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate us'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.store_mall_directory_outlined),
            title: Text('Supplliers'),
            onTap: () {
              Navigator.pushNamed(context, SupplierScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.coffee_maker),
            title: Text('Buy me a coffee'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
