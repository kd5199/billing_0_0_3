import 'dart:io';
import 'package:flutter/foundation.dart';

class SaleBriefModel {
  int invono;
  DateTime date;
  String doctor;
  String customer;
  String email;
  String contact;
  String mode;
  double amount; //q*ptr
  double discount;
  double grandTotal;
  double gstValue;
  File invoice;
  ///////// NEW ///////////////
  String gstin;
  String address;
  String taxable;
  String dlNo;
  double discountAmount;
  String customerId;
  double cgst;
  double sgst;
  double igst;
  String gstMode;

  SaleBriefModel(
      {this.address,
      this.gstMode,
      this.cgst,
      this.sgst,
      this.igst,
      this.gstin,
      this.taxable,
      this.dlNo,
      this.discountAmount,
      this.discount,
      this.invono,
      this.doctor,
      this.grandTotal,
      this.mode,
      this.contact,
      this.customer,
      this.date,
      this.email,
      this.gstValue,
      this.invoice,
      this.amount});
}

class SaleDetailsModel {
  final String customer;
  final String customerId;
  final String contact;
  final String email;
  final DateTime date;
  final int invno;
  //////////////////////////////
  final String productId;
  final int saleQuantity;
  final int free;
  final String package;
  final String title;
  final double mrp;
  final double ptr;
  final double rate;
  final String batch;
  final DateTime exp;
  final double gstPercentage;
  final String barcode;
  final String company;
  final String hsn;
  final double amount;
  final double discountSolo;
  final double taxable;
  final double gstValue;
  final File imageUrl;
  final String rack;

  double cgst;
  double sgst;
  double igst;

  String gstMode;

  SaleDetailsModel(
      {this.customerId,
      this.gstMode,
      this.free,
      this.exp,
      this.email,
      this.ptr,
      this.gstPercentage,
      this.barcode,
      this.amount,
      this.discountSolo,
      this.taxable,
      this.gstValue,
      this.productId,
      this.contact,
      this.customer,
      this.date,
      this.invno,
      this.package,
      this.rate,
      this.batch,
      this.hsn,
      this.title,
      this.company,
      this.saleQuantity,
      this.mrp,
      this.imageUrl,
      this.rack,
      this.cgst,
      this.igst,
      this.sgst});
}

class SaleCartItemModel {
  //////////////////////////////
  final String productId;

  int saleQuantity;
  int free;
  final String package;
  final String title;
  final double mrp;
  final double ptr;
  final double rate;
  final String batch;
  final DateTime exp;
  final double gstPercentage;
  final String barcode;
  final String company;
  final String hsn;
  final double amount;
  double discountSolo;
  double total;
  final double taxable;
  final double gstValue;
  final File imageUrl;
  final String rack;
  double cgst;
  double sgst;
  double igst;

  SaleCartItemModel(
      {this.free,
      this.total,
      this.cgst,
      this.igst,
      this.sgst,
      this.exp,
      this.ptr,
      this.gstPercentage,
      this.barcode,
      this.amount,
      this.discountSolo,
      this.taxable,
      this.gstValue,
      this.productId,
      this.package,
      this.rate,
      this.batch,
      this.hsn,
      this.title,
      this.company,
      this.saleQuantity,
      this.mrp,
      this.imageUrl,
      this.rack});
}
