import 'package:billing_0_0_3_/providers/purchase_brief_provider.dart';
import 'package:billing_0_0_3_/providers/purchase_details_provider.dart';
import 'package:billing_0_0_3_/providers/purchase_report_provider.dart';
import 'package:billing_0_0_3_/providers/sale_cart_provider.dart';
import 'package:billing_0_0_3_/screens/Purchase/purchase_cart_screen.dart';
import 'package:billing_0_0_3_/screens/Purchase/purchase_confirm_screen.dart';
import 'package:billing_0_0_3_/screens/Purchase/purchase_item_confirm.dart';
import 'package:billing_0_0_3_/screens/Purchase/purchase_search.dart';
import 'package:billing_0_0_3_/screens/reports/purchase_detailed_report.dart';
import 'package:billing_0_0_3_/screens/sales/sale_cart_screen.dart';
import 'package:billing_0_0_3_/screens/sales/sale_search_screen.dart';

import './providers/purchase_cart_provider.dart';
import './providers/stock_provider.dart';
import './providers/suppliers.dart';
import './screens/Others/intro_screen.dart';
import './screens/Others/shop_details_screen.dart';
import './screens/Stock/stock_edit_add_screen.dart';
import './screens/Others/suppliers_screen.dart';
import './widgets/common/shop_details_input.dart';
import 'package:provider/provider.dart';
import '../widgets/common/skeleton.dart';
import 'package:flutter/material.dart';
import './providers/shop_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences isopened = await SharedPreferences.getInstance();
  initScreen = isopened.getInt('isopened');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ShopDetailsProvider()),
        ChangeNotifierProvider.value(value: StockProvider()),
        ChangeNotifierProvider.value(value: SupplierProvider()),
        ChangeNotifierProvider.value(value: PurchaseCartProvider()),
        ChangeNotifierProvider.value(value: PurchaseBriefProvider()),
        ChangeNotifierProvider.value(value: PurchaseDetailsProvider()),
        ChangeNotifierProvider.value(value: SupplierProvider()),
        ChangeNotifierProvider.value(value: PurchaseReportProvider()),
        ChangeNotifierProvider.value(value: SaleCartProvider()),
      ],
      child: MaterialApp(
        /* onGenerateRoute: (settings) {
          switch (settings.name) {
            case StockEditAddScreen.routeName:
              return PageTransition(
                child: StockEditAddScreen(),
                type: PageTransitionType.scale,
                alignment: Alignment.bottomRight,
                //duration: Duration(milliseconds: 2000)
              );
              break;
            default:
              return null;
          }
        }, */ //if ongenerateroute there argument i m unable to pass argument yet
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amberAccent,
        ),
        home: MyHomePage(),
        routes: {
          Skeleton.routeName: (ctx) => Skeleton(),
          ShopDetailsScreen.routeName: (ctx) => ShopDetailsScreen(),
          ShopDetailsInputForm.routeName: (ctx) => ShopDetailsInputForm(),
          OnBoardingPage.routeName: (ctx) => OnBoardingPage(),
          SupplierScreen.routeName: (ctx) => SupplierScreen(),
          PurchaseItemConfirm.routeName: (ctx) => PurchaseItemConfirm(),
          PurchaseSearchScreen.routeName: (ctx) => PurchaseSearchScreen(),
          StockEditAddScreen.routeName: (ctx) => StockEditAddScreen(),
          PurchaseCart.routeName: (ctx) => PurchaseCart(),
          PurchaseConfirm.routeName: (ctx) => PurchaseConfirm(),
          PurchaseDetailedReport.routeName: (ctx) => PurchaseDetailedReport(),
          SaleSearchScreen.routeName: (ctx) => SaleSearchScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (initScreen == 0 || initScreen == null)
            ? OnBoardingPage()
            : Skeleton());
  }
}
