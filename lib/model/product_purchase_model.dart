// import 'package:abtxt/model/MDecimal.dart';
//
// class ProductPurchaseModel {
//   int? id;
//   int? firmId;
//   String? firmName;
//   int? slipNo;
//   String? purchaseType;
//   int? suplierId;
//   String? suplierName;
//   String? eDate;
//   int? paAno;
//   String? accountName;
//   String? details;
//   int? referenceNo;
//   List<ProductItem>? productItem;
//
//   ProductPurchaseModel(
//       {this.id,
//       this.firmId,
//       this.firmName,
//       this.slipNo,
//       this.purchaseType,
//       this.suplierId,
//       this.suplierName,
//       this.eDate,
//       this.paAno,
//       this.accountName,
//       this.details,
//       this.referenceNo,
//       this.productItem});
//
//   ProductPurchaseModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     firmId = json['firm_id'];
//     firmName = json['firm_name'];
//     slipNo = json['slip_no'];
//     purchaseType = json['purchase_type'];
//     suplierId = json['suplier_id'];
//     suplierName = json['suplier_name'];
//     eDate = json['e_date'];
//     paAno = json['pa_ano'];
//     accountName = json['account_name'];
//     details = json['details'];
//     referenceNo = json['reference_no'];
//     if (json['product_item'] != null) {
//       productItem = <ProductItem>[];
//       json['product_item'].forEach((v) {
//         productItem!.add(new ProductItem.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['firm_id'] = this.firmId;
//     data['firm_name'] = this.firmName;
//     data['slip_no'] = this.slipNo;
//     data['purchase_type'] = this.purchaseType;
//     data['suplier_id'] = this.suplierId;
//     data['suplier_name'] = this.suplierName;
//     data['e_date'] = this.eDate;
//     data['pa_ano'] = this.paAno;
//     data['account_name'] = this.accountName;
//     data['details'] = this.details;
//     data['reference_no'] = this.referenceNo;
//     if (this.productItem != null) {
//       data['product_item'] = this.productItem!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ProductItem {
//   int? id;
//   int? productPurchaseId;
//   int? productId;
//   int? workNo;
//   int? pieces;
//   int? quantity;
//   int? rate;
//   int? amount;
//   int? rowNo;
//   int? grpNo;
//   Null? prodDet;
//   Null? lotNo;
//   int? lotSerialNo;
//   int? salePerc;
//   int? cgstPerc;
//   int? sgstPerc;
//   int? igstPerc;
//   int? cessPerc;
//   String? taxTyp;
//   int? discPerc;
//   int? discAmount;
//   String? grossRate;
//   String? productName;
//
//   ProductItem(
//       {this.id,
//       this.productPurchaseId,
//       this.productId,
//       this.workNo,
//       this.pieces,
//       this.quantity,
//       this.rate,
//       this.amount,
//       this.rowNo,
//       this.grpNo,
//       this.prodDet,
//       this.lotNo,
//       this.lotSerialNo,
//       this.salePerc,
//       this.cgstPerc,
//       this.sgstPerc,
//       this.igstPerc,
//       this.cessPerc,
//       this.taxTyp,
//       this.discPerc,
//       this.discAmount,
//       this.grossRate,
//       this.productName});
//
//   ProductItem.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productPurchaseId = json['product_purchase_id'];
//     productId = json['product_id'];
//     workNo = json['work_no'];
//     pieces = json['pieces'];
//     quantity = json['quantity'];
//     rate = json['rate'];
//     amount = json['amount'];
//     rowNo = json['row_no'];
//     grpNo = json['grp_no'];
//     prodDet = json['prod_det'];
//     lotNo = json['lot_no'];
//     lotSerialNo = json['lot_serial_no'];
//     salePerc = json['sale_perc'];
//     cgstPerc = json['cgst_perc'];
//     sgstPerc = json['sgst_perc'];
//     igstPerc = json['igst_perc'];
//     cessPerc = json['cess_perc'];
//     taxTyp = json['tax_typ'];
//     discPerc = json['disc_perc'];
//     discAmount = json['disc_amount'];
//     grossRate = json['gross_rate'];
//     productName = json['product_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_purchase_id'] = this.productPurchaseId;
//     data['product_id'] = this.productId;
//     data['work_no'] = this.workNo;
//     data['pieces'] = this.pieces;
//     data['quantity'] = this.quantity;
//     data['rate'] = this.rate;
//     data['amount'] = this.amount;
//     data['row_no'] = this.rowNo;
//     data['grp_no'] = this.grpNo;
//     data['prod_det'] = this.prodDet;
//     data['lot_no'] = this.lotNo;
//     data['lot_serial_no'] = this.lotSerialNo;
//     data['sale_perc'] = this.salePerc;
//     data['cgst_perc'] = this.cgstPerc;
//     data['sgst_perc'] = this.sgstPerc;
//     data['igst_perc'] = this.igstPerc;
//     data['cess_perc'] = this.cessPerc;
//     data['tax_typ'] = this.taxTyp;
//     data['disc_perc'] = this.discPerc;
//     data['disc_amount'] = this.discAmount;
//     data['gross_rate'] = this.grossRate;
//     data['product_name'] = this.productName;
//     return data;
//   }
// }

class ProductPurchaseModel {
  int? id;
  int? firmId;
  String? firmName;
  int? slipNo;
  String? purchaseType;
  int? suplierId;
  String? suplierName;
  String? eDate;
  int? paAno;
  String? accountName;
  String? actBillDate;
  String? dueDays;
  String? details;
  int? referenceNo;
  String? al1Typ;
  int? al1Ano;
  String? al1AnoName;
  dynamic al1Amount;
  dynamic al1Perc;
  String? al2Typ;
  int? al2Ano;
  String? al2AnoName;
  dynamic al2Amount;
  dynamic al2Perc;
  String? al3Typ;
  int? al3Ano;
  String? al3AnoName;
  dynamic al3Amount;
  dynamic al3Perc;
  String? al4Typ;
  int? al4Ano;
  String? al4AnoName;
  dynamic al4Amount;
  dynamic al4Perc;
  dynamic netTotal;
  List<ProductItem>? productItem;

  ProductPurchaseModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.slipNo,
      this.purchaseType,
      this.suplierId,
      this.suplierName,
      this.eDate,
      this.paAno,
      this.accountName,
      this.actBillDate,
      this.dueDays,
      this.details,
      this.referenceNo,
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
      this.netTotal,
      this.productItem});

  ProductPurchaseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    slipNo = json['slip_no'];
    purchaseType = json['purchase_type'];
    suplierId = json['suplier_id'];
    suplierName = json['suplier_name'];
    eDate = json['e_date'];
    paAno = json['pa_ano'];
    accountName = json['account_name'];
    actBillDate = json['act_bill_date'];
    dueDays = json['due_days'];
    details = json['details'];
    referenceNo = json['reference_no'];
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
    netTotal = json['net_total'];
    if (json['product_item'] != null) {
      productItem = <ProductItem>[];
      json['product_item'].forEach((v) {
        productItem!.add(new ProductItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['slip_no'] = this.slipNo;
    data['purchase_type'] = this.purchaseType;
    data['suplier_id'] = this.suplierId;
    data['suplier_name'] = this.suplierName;
    data['e_date'] = this.eDate;
    data['pa_ano'] = this.paAno;
    data['account_name'] = this.accountName;
    data['act_bill_date'] = this.actBillDate;
    data['due_days'] = this.dueDays;
    data['details'] = this.details;
    data['reference_no'] = this.referenceNo;
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
    data['net_total'] = this.netTotal;
    if (this.productItem != null) {
      data['product_item'] = this.productItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductItem {
  int? id;
  int? productPurchaseId;
  int? productId;
  int? workNo;
  int? pieces;
  int? quantity;
  dynamic rate;
  dynamic amount;
  int? rowNo;
  int? grpNo;
  String? prodDet;
  String? lotNo;
  int? lotSerialNo;
  int? salePerc;
  int? cgstPerc;
  int? sgstPerc;
  int? igstPerc;
  int? cessPerc;
  String? taxTyp;
  int? discPerc;
  int? discAmount;
  dynamic grossRate;
  String? productName;

  ProductItem(
      {this.id,
      this.productPurchaseId,
      this.productId,
      this.workNo,
      this.pieces,
      this.quantity,
      this.rate,
      this.amount,
      this.rowNo,
      this.grpNo,
      this.prodDet,
      this.lotNo,
      this.lotSerialNo,
      this.salePerc,
      this.cgstPerc,
      this.sgstPerc,
      this.igstPerc,
      this.cessPerc,
      this.taxTyp,
      this.discPerc,
      this.discAmount,
      this.grossRate,
      this.productName});

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productPurchaseId = json['product_purchase_id'];
    productId = json['product_id'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    quantity = json['quantity'];
    rate = json['rate'];
    amount = json['amount'];
    rowNo = json['row_no'];
    grpNo = json['grp_no'];
    prodDet = json['prod_det'];
    lotNo = json['lot_no'];
    lotSerialNo = json['lot_serial_no'];
    salePerc = json['sale_perc'];
    cgstPerc = json['cgst_perc'];
    sgstPerc = json['sgst_perc'];
    igstPerc = json['igst_perc'];
    cessPerc = json['cess_perc'];
    taxTyp = json['tax_typ'];
    discPerc = json['disc_perc'];
    discAmount = json['disc_amount'];
    grossRate = json['gross_rate'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_purchase_id'] = this.productPurchaseId;
    data['product_id'] = this.productId;
    data['work_no'] = this.workNo;
    data['pieces'] = this.pieces;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['row_no'] = this.rowNo;
    data['grp_no'] = this.grpNo;
    data['prod_det'] = this.prodDet;
    data['lot_no'] = this.lotNo;
    data['lot_serial_no'] = this.lotSerialNo;
    data['sale_perc'] = this.salePerc;
    data['cgst_perc'] = this.cgstPerc;
    data['sgst_perc'] = this.sgstPerc;
    data['igst_perc'] = this.igstPerc;
    data['cess_perc'] = this.cessPerc;
    data['tax_typ'] = this.taxTyp;
    data['disc_perc'] = this.discPerc;
    data['disc_amount'] = this.discAmount;
    data['gross_rate'] = this.grossRate;
    data['product_name'] = this.productName;
    return data;
  }
}
