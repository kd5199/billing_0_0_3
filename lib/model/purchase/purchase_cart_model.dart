class PurchaseCartItemModel {
  final String productId;
  final String title;
  final int quantity;
  final double mrp;
  final double ptr;
  final double rate;
  final String package;
  final int free;
  final String batch;
  final DateTime exp;
  final double gstPercentage;
  final String gstType;
  final double sgst;
  final double cgst;
  final double igst;
  final double gstValue;
  final double taxable;
  final double total;
  final double discountSolo;

  final String company;
  final String barcode;

  final String hsn;
  final String imageUrl;
  final DateTime invoiceDate;
  final String invoiceNo;

  PurchaseCartItemModel(
      {this.barcode,
      this.package,
      this.batch,
      this.company,
      this.invoiceDate,
      this.discountSolo,
      this.exp,
      this.free,
      this.cgst,
      this.sgst,
      this.igst,
      this.gstPercentage,
      this.gstType,
      this.gstValue,
      this.hsn,
      this.productId,
      this.imageUrl,
      this.invoiceNo,
      this.mrp,
      this.ptr,
      this.quantity,
      this.rate,
      this.taxable,
      this.title,
      this.total});
}
