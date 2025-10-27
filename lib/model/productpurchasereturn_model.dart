// class ProductPurchaseReturnModel {
//   int? id;
//   int? firmId;
//   String? firmName;
//   int? suplierId;
//   String? suplierName;
//   String? returnNo;
//   String? returnDate;
//   String? against;
//   String? purchaseNo;
//   String? dcInvoiceNo;
//   int? accountTypeId;
//   String? details;
//   int? totalPieces;
//   int? totalQty;
//   dynamic totalAmount;
//   dynamic totalNetAmount;
//   dynamic discount;
//   dynamic discountRate;
//   dynamic discountAmount;
//   String? transport;
//   dynamic transportRate;
//   dynamic transportAmount;
//   List<ItemDetails>? itemDetails;
//
//   ProductPurchaseReturnModel(
//       {this.id,
//       this.firmId,
//       this.firmName,
//       this.suplierId,
//       this.suplierName,
//       this.returnNo,
//       this.returnDate,
//       this.against,
//       this.purchaseNo,
//       this.dcInvoiceNo,
//       this.accountTypeId,
//       this.details,
//       this.totalPieces,
//       this.totalQty,
//       this.totalAmount,
//       this.totalNetAmount,
//       this.discount,
//       this.discountRate,
//       this.discountAmount,
//       this.transport,
//       this.transportRate,
//       this.transportAmount,
//       this.itemDetails});
//
//   ProductPurchaseReturnModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     firmId = json['firm_id'];
//     firmName = json['firm_name'];
//     suplierId = json['suplier_id'];
//     suplierName = json['suplier_name'];
//     returnNo = json['return_no'];
//     returnDate = json['return_date'];
//     against = json['against'];
//     purchaseNo = json['purchase_no'];
//     dcInvoiceNo = json['dc_invoice_no'];
//     accountTypeId = json['account_type_id'];
//     details = json['details'];
//     totalPieces = json['total_pieces'];
//     totalQty = json['total_qty'];
//     totalAmount = json['total_amount'];
//     totalNetAmount = json['total_net_amount'];
//     discount = json['discount'];
//     discountRate = json['discount_rate'];
//     discountAmount = json['discount_amount'];
//     transport = json['transport'];
//     transportRate = json['transport_rate'];
//     transportAmount = json['transport_amount'];
//     if (json['item_details'] != null) {
//       itemDetails = <ItemDetails>[];
//       json['item_details'].forEach((v) {
//         itemDetails!.add(new ItemDetails.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['firm_id'] = this.firmId;
//     data['firm_name'] = this.firmName;
//     data['suplier_id'] = this.suplierId;
//     data['suplier_name'] = this.suplierName;
//     data['return_no'] = this.returnNo;
//     data['return_date'] = this.returnDate;
//     data['against'] = this.against;
//     data['purchase_no'] = this.purchaseNo;
//     data['dc_invoice_no'] = this.dcInvoiceNo;
//     data['account_type_id'] = this.accountTypeId;
//     data['details'] = this.details;
//     data['total_pieces'] = this.totalPieces;
//     data['total_qty'] = this.totalQty;
//     data['total_amount'] = this.totalAmount;
//     data['total_net_amount'] = this.totalNetAmount;
//     data['discount'] = this.discount;
//     data['discount_rate'] = this.discountRate;
//     data['discount_amount'] = this.discountAmount;
//     data['transport'] = this.transport;
//     data['transport_rate'] = this.transportRate;
//     data['transport_amount'] = this.transportAmount;
//     if (this.itemDetails != null) {
//       data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ItemDetails {
//   int? id;
//   int? productId;
//   String? designNo;
//   String? workStatus;
//   String? workDetails;
//   int? pieces;
//   int? qty;
//   dynamic rate;
//   dynamic netAmount;
//   int? stock;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   int? productPurchaseReturnId;
//   String? productName;
//
//   ItemDetails(
//       {this.id,
//       this.productId,
//       this.designNo,
//       this.workStatus,
//       this.workDetails,
//       this.pieces,
//       this.qty,
//       this.rate,
//       this.netAmount,
//       this.stock,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.productPurchaseReturnId,
//       this.productName});
//
//   ItemDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     designNo = json['design_no'];
//     workStatus = json['work_status'];
//     workDetails = json['work_details'];
//     pieces = json['pieces'];
//     qty = json['qty'];
//     rate = json['rate'];
//     netAmount = json['net_amount'];
//     stock = json['stock'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     productPurchaseReturnId = json['product_purchase_return_id'];
//     productName = json['product_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_id'] = this.productId;
//     data['design_no'] = this.designNo;
//     data['work_status'] = this.workStatus;
//     data['work_details'] = this.workDetails;
//     data['pieces'] = this.pieces;
//     data['qty'] = this.qty;
//     data['rate'] = this.rate;
//     data['net_amount'] = this.netAmount;
//     data['stock'] = this.stock;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['product_purchase_return_id'] = this.productPurchaseReturnId;
//     data['product_name'] = this.productName;
//     return data;
//   }
// }

class ProductPurchaseReturnModel {
  int? id;
  int? firmId;
  String? firmName;
  int? suplierId;
  String? suplierName;
  String? purRetTyp;
  int? prAno;
  String? accountName;
  int? referenceNo;
  String? eDate;
  String? against;
  String? details;
  String? al1Typ;
  int? al1Ano;
  String? al1AnoName;
  dynamic? al1Amount;
  dynamic? al1Perc;
  String? al2Typ;
  int? al2Ano;
  String? al2AnoName;
  dynamic? al2Amount;
  dynamic? al2Perc;
  String? al3Typ;
  int? al3Ano;
  String? al3AnoName;
  dynamic? al3Amount;
  dynamic? al3Perc;
  String? al4Typ;
  int? al4Ano;
  String? al4AnoName;
  dynamic? al4Amount;
  dynamic? al4Perc;
  List<ItemDetails>? itemDetails;

  ProductPurchaseReturnModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.suplierId,
      this.suplierName,
      this.purRetTyp,
      this.prAno,
      this.accountName,
      this.referenceNo,
      this.eDate,
      this.against,
      this.details,
      this.al1Typ,
      this.al1Ano,
      this.al1AnoName,
      this.al1Amount,
      this.al1Perc,
      this.al2Typ,
      this.al2Ano,
      this.al2AnoName,
      this.al2Amount,
      this.al2Perc,
      this.al3Typ,
      this.al3Ano,
      this.al3AnoName,
      this.al3Amount,
      this.al3Perc,
      this.al4Typ,
      this.al4Ano,
      this.al4AnoName,
      this.al4Amount,
      this.al4Perc,
      this.itemDetails});

  ProductPurchaseReturnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    suplierId = json['suplier_id'];
    suplierName = json['suplier_name'];
    purRetTyp = json['pur_ret_typ'];
    prAno = json['pr_ano'];
    accountName = json['account_name'];
    referenceNo = json['reference_no'];
    eDate = json['e_date'];
    against = json['against'];
    details = json['details'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1AnoName = json['al1_ano_name'];
    al1Amount = json['al1_amount'];
    al1Perc = json['al1_perc'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2AnoName = json['al2_ano_name'];
    al2Amount = json['al2_amount'];
    al2Perc = json['al2_perc'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3AnoName = json['al3_ano_name'];
    al3Amount = json['al3_amount'];
    al3Perc = json['al3_perc'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al4AnoName = json['al4_ano_name'];
    al4Amount = json['al4_amount'];
    al4Perc = json['al4_perc'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['suplier_id'] = this.suplierId;
    data['suplier_name'] = this.suplierName;
    data['pur_ret_typ'] = this.purRetTyp;
    data['pr_ano'] = this.prAno;
    data['account_name'] = this.accountName;
    data['reference_no'] = this.referenceNo;
    data['e_date'] = this.eDate;
    data['against'] = this.against;
    data['details'] = this.details;
    data['al1_typ'] = this.al1Typ;
    data['al1_ano'] = this.al1Ano;
    data['al1_ano_name'] = this.al1AnoName;
    data['al1_amount'] = this.al1Amount;
    data['al1_perc'] = this.al1Perc;
    data['al2_typ'] = this.al2Typ;
    data['al2_ano'] = this.al2Ano;
    data['al2_ano_name'] = this.al2AnoName;
    data['al2_amount'] = this.al2Amount;
    data['al2_perc'] = this.al2Perc;
    data['al3_typ'] = this.al3Typ;
    data['al3_ano'] = this.al3Ano;
    data['al3_ano_name'] = this.al3AnoName;
    data['al3_amount'] = this.al3Amount;
    data['al3_perc'] = this.al3Perc;
    data['al4_typ'] = this.al4Typ;
    data['al4_ano'] = this.al4Ano;
    data['al4_ano_name'] = this.al4AnoName;
    data['al4_amount'] = this.al4Amount;
    data['al4_perc'] = this.al4Perc;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? productPurchaseReturnId;
  int? productId;
  String? workNo;
  int? pieces;
  int? quantity;
  int? rate;
  dynamic? amount;
  Null? rowNo;
  Null? grpNo;
  Null? prodDet;
  Null? lotSerialNo;
  Null? cgstPerc;
  Null? sgstPerc;
  Null? igstPerc;
  Null? cessPerc;
  Null? taxTyp;
  Null? grossRate;
  Null? discPerc;
  Null? discAmount;
  String? createdAt;
  String? updatedAt;
  String? productName;

  ItemDetails(
      {this.id,
      this.productPurchaseReturnId,
      this.productId,
      this.workNo,
      this.pieces,
      this.quantity,
      this.rate,
      this.amount,
      this.rowNo,
      this.grpNo,
      this.prodDet,
      this.lotSerialNo,
      this.cgstPerc,
      this.sgstPerc,
      this.igstPerc,
      this.cessPerc,
      this.taxTyp,
      this.grossRate,
      this.discPerc,
      this.discAmount,
      this.createdAt,
      this.updatedAt,
      this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productPurchaseReturnId = json['product_purchase_return_id'];
    productId = json['product_id'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    quantity = json['quantity'];
    rate = json['rate'];
    amount = json['amount'];
    rowNo = json['row_no'];
    grpNo = json['grp_no'];
    prodDet = json['prod_det'];
    lotSerialNo = json['lot_serial_no'];
    cgstPerc = json['cgst_perc'];
    sgstPerc = json['sgst_perc'];
    igstPerc = json['igst_perc'];
    cessPerc = json['cess_perc'];
    taxTyp = json['tax_typ'];
    grossRate = json['gross_rate'];
    discPerc = json['disc_perc'];
    discAmount = json['disc_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_purchase_return_id'] = this.productPurchaseReturnId;
    data['product_id'] = this.productId;
    data['work_no'] = this.workNo;
    data['pieces'] = this.pieces;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['row_no'] = this.rowNo;
    data['grp_no'] = this.grpNo;
    data['prod_det'] = this.prodDet;
    data['lot_serial_no'] = this.lotSerialNo;
    data['cgst_perc'] = this.cgstPerc;
    data['sgst_perc'] = this.sgstPerc;
    data['igst_perc'] = this.igstPerc;
    data['cess_perc'] = this.cessPerc;
    data['tax_typ'] = this.taxTyp;
    data['gross_rate'] = this.grossRate;
    data['disc_perc'] = this.discPerc;
    data['disc_amount'] = this.discAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_name'] = this.productName;
    return data;
  }
}
