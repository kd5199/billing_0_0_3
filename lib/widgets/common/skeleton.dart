import 'package:billing_0_0_3_/screens/reports/reports_home.dart';
import 'package:billing_0_0_3_/screens/sales/sale_cart_screen.dart';

import '../../screens/Purchase/purchase_cart_screen.dart';
import 'package:flutter/material.dart';
import '../../screens/Stock/stock_screen.dart';

class Skeleton extends StatefulWidget {
  //const Skeleton({ Key? key }) : super(key: key);
  static const routeName = '/skeletonscreen';
  @override
  SkeletonState createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> {
  static int selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    PurchaseCart(),
    Stock(),
    SaleCartScreen(),
    ReportsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_shopping_cart_rounded,
              color: Colors.grey,
            ),
            label: 'Purchase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory, color: Colors.grey),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined, color: Colors.grey),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined, color: Colors.grey),
            label: 'Reports',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
