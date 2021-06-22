import 'package:billing_0_0_3_/widgets/common/drawer.dart';
import 'package:flutter/material.dart';

class SaleConfirmScreen extends StatefulWidget {

  @override
  _SaleConfirmScreenState createState() => _SaleConfirmScreenState();
}

class _SaleConfirmScreenState extends State<SaleConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Sale'), centerTitle: true,),
      body: Form(child: 
      Column(children: [
        
      ],),),
    );
  }
}