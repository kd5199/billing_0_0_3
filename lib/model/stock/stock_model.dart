import 'dart:io';

class StockItemModel {
  final String id;
  final int quantity; ////////////
  final String package; //////////
  final String title; //////////////
  double mrp; ///////////////////
  double ptr; /////////////////////
  double rate; /////////////////
  String batch; ////////////
  DateTime exp;
  double gstPercentage; //////////
  final String company; /////////////
  final String barcode;
  final String hsn; ////////////////////
  final File imageUrl;
  String rack;

  StockItemModel({
    this.rack,
    this.package,
    this.barcode,
    this.batch,
    this.company,
    this.exp,
    this.gstPercentage,
    this.hsn,
    this.id,
    this.imageUrl,
    this.mrp,
    this.ptr,
    this.quantity,
    this.rate,
    this.title,
  });
}
