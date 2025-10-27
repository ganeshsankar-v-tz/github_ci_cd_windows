class YarnPurchaseModel {
  int? id;
  int? supplierId;
  String? supplierName;
  int? firmId;
  String? firmName;
  int? paAno;
  String? accountName;
  String? invoiceNo;
  String? purchaseDate;
  String? details;
  String? boxNo;
  String? pack;
  int? slipNo;
  String? actBillDate;
  int? dueDays;
  String? al1Typ;
  int? al1Ano;
  dynamic al1Amount;
  dynamic al1Perc;
  String? al2Typ;
  int? al2Ano;
  dynamic al2Amount;
  dynamic al2Perc;
  String? al3Typ;
  int? al3Ano;
  dynamic al3Amount;
  int? al3Perc;
  String? al4Typ;
  int? al4Ano;
  dynamic al4Amount;
  dynamic al4Perc;
  dynamic roundOff;
  dynamic netTotal;
  List<ItemDetails>? itemDetails;

  YarnPurchaseModel(
      {this.id,
      this.supplierId,
      this.supplierName,
      this.firmId,
      this.firmName,
      this.paAno,
      this.accountName,
      this.invoiceNo,
      this.purchaseDate,
      this.details,
      this.boxNo,
      this.pack,
      this.slipNo,
      this.actBillDate,
      this.dueDays,
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
      this.roundOff,
      this.netTotal,
      this.itemDetails});

  YarnPurchaseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    paAno = json['pa_ano'];
    accountName = json['account_name'];
    invoiceNo = json['invoice_no'];
    purchaseDate = json['purchase_date'];
    details = json['details'];
    boxNo = json['box_no'];
    pack = json['pack'];
    slipNo = json['slip_no'];
    actBillDate = json['act_bill_date'];
    dueDays = json['due_days'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1Amount = json['al1_amount'];
    al1Perc = json['al1_perc'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2Amount = json['al2_amount'];
    al2Perc = json['al2_perc'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3Amount = json['al3_amount'];
    al3Perc = json['al3_perc'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al4Amount = json['al4_amount'];
    al4Perc = json['al4_perc'];
    roundOff = json['round_off'];
    netTotal = json['net_total'];
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
    data['supplier_id'] = this.supplierId;
    data['supplier_name'] = this.supplierName;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['pa_ano'] = this.paAno;
    data['account_name'] = this.accountName;
    data['invoice_no'] = this.invoiceNo;
    data['purchase_date'] = this.purchaseDate;
    data['details'] = this.details;
    data['box_no'] = this.boxNo;
    data['pack'] = this.pack;
    data['slip_no'] = this.slipNo;
    data['act_bill_date'] = this.actBillDate;
    data['due_days'] = this.dueDays;
    data['al1_typ'] = this.al1Typ;
    data['al1_ano'] = this.al1Ano;
    data['al1_amount'] = this.al1Amount;
    data['al1_perc'] = this.al1Perc;
    data['al2_typ'] = this.al2Typ;
    data['al2_ano'] = this.al2Ano;
    data['al2_amount'] = this.al2Amount;
    data['al2_perc'] = this.al2Perc;
    data['al3_typ'] = this.al3Typ;
    data['al3_ano'] = this.al3Ano;
    data['al3_amount'] = this.al3Amount;
    data['al3_perc'] = this.al3Perc;
    data['al4_typ'] = this.al4Typ;
    data['al4_ano'] = this.al4Ano;
    data['al4_amount'] = this.al4Amount;
    data['al4_perc'] = this.al4Perc;
    data['round_off'] = this.roundOff;
    data['net_total'] = this.netTotal;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnPurchaseId;
  int? yarnId;
  String? colourName;
  int? colourId;
  String? stockTo;
  String? boxNo;
  int? pack;
  // dynamic itemQuantity;
  // dynamic less;
  dynamic netQuantity;
  String? calculateType;
  dynamic rate;
  dynamic amount;
  int? rowNo;
  int? crNo;
  int? rcdCr;
  int? rtnCr;
  int? purCr;
  int? purCrLess;
  int? purCrCost;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.yarnPurchaseId,
      this.yarnId,
      this.colourName,
      this.colourId,
      this.stockTo,
      this.boxNo,
      this.pack,
      // this.itemQuantity,
      // this.less,
      this.netQuantity,
      this.calculateType,
      this.rate,
      this.amount,
      this.rowNo,
      this.crNo,
      this.rcdCr,
      this.rtnCr,
      this.purCr,
      this.purCrLess,
      this.purCrCost,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnPurchaseId = json['yarn_purchase_id'];
    yarnId = json['yarn_id'];
    colourName = json['colour_name'];
    colourId = json['color_id'];
    stockTo = json['stock_to'];
    boxNo = json['box_no'];
    pack = json['pack'];
    // itemQuantity = json['item_quantity'];
    // less = json['less'];
    netQuantity = json['net_quantity'];
    calculateType = json['calculate_type'];
    rate = json['rate'];
    amount = json['amount'];
    rowNo = json['row_no'];
    crNo = json['cr_no'];
    rcdCr = json['rcd_cr'];
    rtnCr = json['rtn_cr'];
    purCr = json['pur_cr'];
    purCrLess = json['pur_cr_less'];
    purCrCost = json['pur_cr_cost'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_purchase_id'] = this.yarnPurchaseId;
    data['yarn_id'] = this.yarnId;
    data['colour_name'] = this.colourName;
    data['color_id'] = this.colourId;
    data['stock_to'] = this.stockTo;
    data['box_no'] = this.boxNo;
    data['pack'] = this.pack;
    // data['item_quantity'] = this.itemQuantity;
    // data['less'] = this.less;
    data['net_quantity'] = this.netQuantity;
    data['calculate_type'] = this.calculateType;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['row_no'] = this.rowNo;
    data['cr_no'] = this.crNo;
    data['rcd_cr'] = this.rcdCr;
    data['rtn_cr'] = this.rtnCr;
    data['pur_cr'] = this.purCr;
    data['pur_cr_less'] = this.purCrLess;
    data['pur_cr_cost'] = this.purCrCost;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
