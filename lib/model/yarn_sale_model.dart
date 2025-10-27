class YarnSaleModel {
  int? id;
  int? customerId;
  String? customerName;
  int? firmId;
  String? firmName;
  int? salesAno;
  String? accountTypeName;
  String? destinationTo;
  String? destinationName;
  int? billNO;
  String? freight;
  String? salesDate;
  String? lrNo;
  String? lrDate;
  String? details;
  String? boxNo;
  String? transportType;
  int? packTotal;
  num? quantityTotal;
  num? roundOff;
  num? amountTotal;
  num? netTotal;
  String? discount;
  num? discountRate;
  num? discountAmount;
  String? transport;
  num? transportRate;
  num? transportAmount;
  String? al1Typ;
  int? al1Ano;
  String? al1AnoName;
  num? al1Amount;
  num? al1Perc;
  String? al2Typ;
  int? al2Ano;
  String? al2AnoName;
  num? al2Amount;
  num? al2Perc;
  String? al3Typ;
  int? al3Ano;
  String? al3AnoName;
  num? al3Amount;
  int? al3Perc;
  String? al4Typ;
  int? al4Ano;
  String? al4AnoName;
  num? al4Amount;
  num? al4Perc;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  YarnSaleModel(
      {this.id,
      this.customerId,
      this.customerName,
      this.firmId,
      this.firmName,
      this.salesAno,
      this.accountTypeName,
      this.destinationTo,
      this.destinationName,
      this.billNO,
      this.freight,
      this.salesDate,
      this.roundOff,
      this.lrNo,
      this.lrDate,
      this.details,
      this.boxNo,
      this.transportType,
      this.packTotal,
      this.quantityTotal,
      this.amountTotal,
      this.netTotal,
      this.discount,
      this.discountRate,
      this.discountAmount,
      this.transport,
      this.transportRate,
      this.transportAmount,
      this.al1Typ,
      this.al1Ano,
      this.al1Amount,
      this.al1Perc,
      this.al2Typ,
      this.al2Ano,
      this.al2Amount,
      this.al2Perc,
      this.al3Typ,
      this.al3Ano,
      this.al3Amount,
      this.al3Perc,
      this.al4Typ,
      this.al4Ano,
      this.al4Amount,
      this.al4Perc,
      this.creatorName,
      this.updatedName,
      this.createdAt,
      this.updatedAt,
      this.itemDetails});

  YarnSaleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    salesAno = json['sales_ano'];
    accountTypeName = json['account_type_name'];
    destinationTo = json['destination_to'];
    destinationName = json['destination_name'];
    billNO = json['bill_no'];
    freight = json['freight'];
    salesDate = json['sales_date'];
    lrNo = json['lr_no'];
    roundOff = json['round_off'];
    lrDate = json['lr_date'];
    details = json['details'];
    boxNo = json['box_no'];
    transportType = json['transport_type'];
    packTotal = json['pack_total'];
    quantityTotal = json['quantity_total'];
    amountTotal = json['amount_total'];
    netTotal = json['net_total'];
    discount = json['discount'];
    discountRate = json['discount_rate'];
    discountAmount = json['discount_amount'];
    transport = json['transport'];
    transportRate = json['transport_rate'];
    transportAmount = json['transport_amount'];
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
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['sales_ano'] = salesAno;
    data['account_type_name'] = accountTypeName;
    data['destination_to'] = destinationTo;
    data['destination_name'] = destinationName;
    data['bill_no'] = billNO;
    data['freight'] = freight;
    data['sales_date'] = salesDate;
    data['lr_no'] = lrNo;
    data['lr_date'] = lrDate;
    data['details'] = details;
    data['box_no'] = boxNo;
    data['round_off'] = roundOff;
    data['transport_type'] = transportType;
    data['pack_total'] = packTotal;
    data['quantity_total'] = quantityTotal;
    data['amount_total'] = amountTotal;
    data['net_total'] = netTotal;
    data['discount'] = discount;
    data['discount_rate'] = discountRate;
    data['discount_amount'] = discountAmount;
    data['transport'] = transport;
    data['transport_rate'] = transportRate;
    data['transport_amount'] = transportAmount;
    data['al1_typ'] = al1Typ;
    data['al1_ano'] = al1Ano;
    data['al1_amount'] = al1Amount;
    data['al1_perc'] = al1Perc;
    data['al2_typ'] = al2Typ;
    data['al2_ano'] = al2Ano;
    data['al2_amount'] = al2Amount;
    data['al2_perc'] = al2Perc;
    data['al3_typ'] = al3Typ;
    data['al3_ano'] = al3Ano;
    data['al3_amount'] = al3Amount;
    data['al3_perc'] = al3Perc;
    data['al4_typ'] = al4Typ;
    data['al4_ano'] = al4Ano;
    data['al4_amount'] = al4Amount;
    data['al4_perc'] = al4Perc;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnSaleId;
  int? colorId;
  int? yarnId;
  String? stock;
  String? boxNo;
  int? pack;
  num? rate;
  num? amount;
  String? createdAt;
  String? updatedAt;
  String? calculateType;
  num? grossQuantity;
  String? stockIn;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.yarnSaleId,
      this.colorId,
      this.yarnId,
      this.stock,
      this.boxNo,
      this.pack,
      // this.quantity,
      this.rate,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.calculateType,
      this.grossQuantity,
      // this.lessQuantity,
      this.stockIn,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnSaleId = json['yarn_sale_id'];
    colorId = json['color_id'];
    yarnId = json['yarn_id'];
    stock = json['stock'];
    boxNo = json['box_no'];
    pack = json['pack'];
    rate = json['rate'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    calculateType = json['calculate_type'];
    grossQuantity = json['gross_quantity'];
    stockIn = json['stock_in'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['yarn_sale_id'] = yarnSaleId;
    data['color_id'] = colorId;
    data['yarn_id'] = yarnId;
    data['stock'] = stock;
    data['box_no'] = boxNo;
    data['pack'] = pack;
    data['rate'] = rate;
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['calculate_type'] = calculateType;
    data['gross_quantity'] = grossQuantity;
    data['stock_in'] = stockIn;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    return data;
  }
}
