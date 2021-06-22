import 'package:flutter/material.dart';
import '../../widgets/common/shop_details_input.dart';
import 'package:flutter/services.dart';

class OnBoardingPage extends StatefulWidget {
  //const OnBoardingPage({ Key? key }) : super(key: key);
  static const routeName = '/OnBoardingPage';

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
          centerTitle: true,
          bottomOpacity: 0,
          title: Text(
            'Form',
            textAlign: TextAlign.center,
          )), */
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Chip(
                  label: Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              Text(
                'We need some details to start off.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ShopDetailsInputForm(),
            ],
          ),
        ),
      ),
    );
  }
}
