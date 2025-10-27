class ProductSalesModel {
  int? id;
  int? firmId;
  int? customerId;
  String? eDate;
  int? saAno;
  num? netTotal;
  int? billNo;
  String? transport;
  String? orderNo;
  String? order;
  String? details;
  String? al1Typ;
  int? al1Ano;
  num? al1Perc;
  num? al1Amount;
  String? al2Typ;
  int? al2Ano;
  num? al2Perc;
  num? al2Amount;
  String? al3Typ;
  int? al3Ano;
  num? al3Perc;
  num? al3Amount;
  String? al4Typ;
  int? al4Ano;
  num? al4Perc;
  num? al4Amount;
  num? roundOff;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? freight;
  String? lrDate;
  String? lrNo;
  int? noOfBags;
  String? firmName;
  String? salesAccountName;
  String? customerName;
  String? al1AnoName;
  String? al2AnoName;
  String? al3AnoName;
  String? al4AnoName;
  String? creatorName;
  String? updatedName;
  int? totalQty;
  List<ProductSaleDetails>? productSaleDetails;

  ProductSalesModel({
    this.id,
    this.firmId,
    this.customerId,
    this.eDate,
    this.saAno,
    this.netTotal,
    this.billNo,
    this.transport,
    this.orderNo,
    this.order,
    this.details,
    this.al1Typ,
    this.al1Ano,
    this.al1Perc,
    this.al1Amount,
    this.al2Typ,
    this.al2Ano,
    this.al2Perc,
    this.al2Amount,
    this.al3Typ,
    this.al3Ano,
    this.al3Perc,
    this.al3Amount,
    this.al4Typ,
    this.al4Ano,
    this.al4Perc,
    this.al4Amount,
    this.roundOff,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.freight,
    this.lrDate,
    this.lrNo,
    this.noOfBags,
    this.firmName,
    this.salesAccountName,
    this.customerName,
    this.al1AnoName,
    this.al2AnoName,
    this.al3AnoName,
    this.al4AnoName,
    this.creatorName,
    this.updatedName,
    this.totalQty,
    this.productSaleDetails,
  });

  ProductSalesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    customerId = json['customer_id'];
    eDate = json['e_date'];
    saAno = json['sa_ano'];
    netTotal = json['net_total'];
    billNo = json['bill_no'];
    transport = json['transport'];
    orderNo = json['order_no'];
    order = json['order'];
    details = json['details'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1Perc = json['al1_perc'];
    al1Amount = json['al1_amount'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2Perc = json['al2_perc'];
    al2Amount = json['al2_amount'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3Perc = json['al3_perc'];
    al3Amount = json['al3_amount'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al4Perc = json['al4_perc'];
    al4Amount = json['al4_amount'];
    roundOff = json['round_off'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freight = json['freight'];
    lrDate = json['lr_date'];
    lrNo = json['lr_no'];
    noOfBags = json['no_of_bags'];
    firmName = json['firm_name'];
    salesAccountName = json['sales_account_name'];
    customerName = json['customer_name'];
    al1AnoName = json['al1_ano_name'];
    al2AnoName = json['al2_ano_name'];
    al3AnoName = json['al3_ano_name'];
    al4AnoName = json['al4_ano_name'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    totalQty = json['total_qty'];
    if (json['product_sale_details'] != null) {
      productSaleDetails = <ProductSaleDetails>[];
      json['product_sale_details'].forEach((v) {
        productSaleDetails!.add(ProductSaleDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firm_id'] = firmId;
    data['customer_id'] = customerId;
    data['e_date'] = eDate;
    data['sa_ano'] = saAno;
    data['net_total'] = netTotal;
    data['bill_no'] = billNo;
    data['transport'] = transport;
    data['order_no'] = orderNo;
    data['order'] = order;
    data['details'] = details;
    data['al1_typ'] = al1Typ;
    data['al1_ano'] = al1Ano;
    data['al1_perc'] = al1Perc;
    data['al1_amount'] = al1Amount;
    data['al2_typ'] = al2Typ;
    data['al2_ano'] = al2Ano;
    data['al2_perc'] = al2Perc;
    data['al2_amount'] = al2Amount;
    data['al3_typ'] = al3Typ;
    data['al3_ano'] = al3Ano;
    data['al3_perc'] = al3Perc;
    data['al3_amount'] = al3Amount;
    data['al4_typ'] = al4Typ;
    data['al4_ano'] = al4Ano;
    data['al4_perc'] = al4Perc;
    data['al4_amount'] = al4Amount;
    data['round_off'] = roundOff;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['freight'] = freight;
    data['lr_date'] = lrDate;
    data['lr_no'] = lrNo;
    data['no_of_bags'] = noOfBags;
    data['firm_name'] = firmName;
    data['sales_account_name'] = salesAccountName;
    data['customer_name'] = customerName;
    data['al1_ano_name'] = al1AnoName;
    data['al2_ano_name'] = al2AnoName;
    data['al3_ano_name'] = al3AnoName;
    data['al4_ano_name'] = al4AnoName;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['total_qty'] = totalQty;
    if (productSaleDetails != null) {
      data['product_sale_details'] =
          productSaleDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductSaleDetails {
  int? id;
  int? productSaleId;
  int? productId;
  int? qty;
  num? rate;
  num? amount;
  String? details;
  int? bagBals;
  String? productName;
  String? designNo;

  ProductSaleDetails({
    this.id,
    this.productSaleId,
    this.productId,
    this.qty,
    this.rate,
    this.amount,
    this.details,
    this.bagBals,
    this.productName,
    this.designNo,
  });

  ProductSaleDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSaleId = json['product_sale_id'];
    productId = json['product_id'];
    qty = json['qty'];
    rate = json['rate'];
    amount = json['amount'];
    details = json['details'];
    bagBals = json['bag_bals'];
    productName = json['product_name'];
    designNo = json['design_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_sale_id'] = productSaleId;
    data['product_id'] = productId;
    data['qty'] = qty;
    data['rate'] = rate;
    data['amount'] = amount;
    data['details'] = details;
    data['bag_bals'] = bagBals;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    return data;
  }
}
